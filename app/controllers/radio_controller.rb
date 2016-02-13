require 'action_view'

class RadioController < ApplicationController
  skip_before_action :authorize, only: [:index, :info, :request_song]

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
    IreulWeb::Application.ireul_client.enqueue(song)

    render json: {
      status: :ok,
      action: :enqueue,
      time: Time.now.utc,
      canRequestAt: @song.can_request_at
    }
  rescue IreulService::IreulConnError
    render json: { status: :failure, action: :enqueue, time: Time.now.utc }
  end

  def request_song
    @song = Song.find(params[:id])
    if @song.can_request?
      @song.last_requested_at = Time.now.utc
      @song.save
      enqueue
    else
      next_request_at = @song.can_request_at
      human_time = distance_of_time_in_words(next_request_at, Time.now.utc)
      render json: {
        status: :failure,
        status_message: 'Cannot request this song yet. ' \
                        "Try again at #{next_request_at} (#{human_time})",
        action: :request,
        time: Time.now.utc
      }
    end
  end

  # TODO: Replace polling with ActionCable with Rails 5
  # TODO: Optimise this
  def info
    queue = IreulWeb::Application.ireul_client.queue_status
    upcoming = queue.upcoming || []
    history = queue.history || []

    unless queue.current.nil?
      handle = queue.current.instance_variable_get('@track').handle[0]
      song_id = IreulWeb::Application.handle_map[handle]
      song = Song.find_by_id(song_id)
      bg_image = BackgroundImage.where(song_id: song.id).first if song
      image_url = bg_image.image.url(:small) if bg_image # TODO: Add fallback images
    end

    render json: {
      image: image_url || nil,
      current: queue_track_to_json(queue.current),
      upcoming: upcoming.map { |t| queue_track_to_json(t) },
      history: history.map { |t| queue_track_to_json(t) }
    }
  end

  private

  def song_params
    params.require(:song).permit(:song_id)
  end

  def queue_track_to_json(t)
    return nil if t.nil?

    {
      artist: t.artist.force_encoding('utf-8'),
      album: t.album.force_encoding('utf-8'),
      title: t.title.force_encoding('utf-8'),
      position: t.position,
      duration: t.duration,
      start_time: t.try(:start_time)
    }
  end
end
