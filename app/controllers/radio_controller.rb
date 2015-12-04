require 'action_view'

class RadioController < ApplicationController
  include ActionView::Helpers::DateHelper

  def index
  end

  def skip
    IreulWeb::Application.ireul_client.fast_forward(:track_boundary)
    render json: { status: :ok, action: :skip, time: Time.now.utc }
  rescue IreulService::IreulConnError
    render json: { status: :failure, action: :skip, time: Time.now.utc }
  end

  def enqueue
    song ||= @song || Song.find(params[:id])
    oggfile = open(song.file.path, 'rb')
    oggbuf = oggfile.read()
    oggfile.close()
    IreulWeb::Application.ireul_client.enqueue(oggbuf)

    render json: { status: :ok, action: :enqueue, time: Time.now.utc, canRequestAt: @song.can_request_at }
  rescue IreulService::IreulConnError
    render json: { status: :failure, action: :enqueue, time: Time.now.utc }
  end

  def request_song
    @song = Song.find(params[:id])
    if @song.can_request?
      @song.last_requested_at = DateTime.now
      @song.save
      enqueue
    else
      next_request_at = @song.can_request_at
      human_time = distance_of_time_in_words(next_request_at, Time.zone.now)
      render json: {
        status: :failure,
        status_message: "Cannot request this song yet, try again at #{next_request_at} (#{human_time})",
        action: :request,
        time: Time.now.utc
      }
    end
  end

  def info
    @artist = "Some artist"
    @title = "Some title"
    @image = BackgroundImage.where(song_id: params[:song_id]).first.image.url(:medium) # replace param with current song

    respond_to do |format|
      format.json
    end
  end

  private

  def song_params
    params.require(:song).permit(:song_id)
  end
end
