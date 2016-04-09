require 'action_view'

class RadioController < ApplicationController
  skip_before_action :authorize, only: [:index, :info, :request_song, :nice]

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
    @song = Song.find(params[:id])
    IreulWeb::Application.ireul_client.enqueue(@song)

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

  def nice
    queue = IreulWeb::Application.ireul_client.queue_status
    track = queue.current.instance_variable_get('@track')
    nice_map = IreulWeb::Application.nice_map
    nice_voted_ips = IreulWeb::Application.nice_voted_ips

    nice_voted_ips[request.remote_ip] = {} if nice_voted_ips[request.remote_ip].nil?

    if track && !nice_voted_ips[request.remote_ip][track.handle]
      handle = track.handle
      nice_map[handle] = 0 if nice_map[handle].nil?
      nice_map[handle] += 1
      nice_voted_ips[request.remote_ip][handle] = true

      log_entry = "[radio.nice] #{nice_map[handle]}\t#{track.artist}\t#{track.title}\t#{request.remote_ip}".force_encoding('UTF-8')
      Rails.logger.info log_entry
      IreulWeb::Application.nice_logger.info log_entry if !Rails.env.test?

      render json: {
        status: :ok,
        status_message: 'いいね～',
        action: :nice,
        time: Time.now.utc
      }
    else
      render json: {
        status: :failure,
        status_message: "Already nice! (#{nice_map[handle].to_s})",
        action: :nice,
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
      handle = queue.current.instance_variable_get('@track').handle
      song_id = IreulWeb::Application.handle_map[handle]
      song = Song.find_by_id(song_id)
      bg_image = BackgroundImage.where(song_id: song.id).first if song
      image_url = bg_image.image.url(:small) if bg_image # TODO: Add fallback images
      niceness = IreulWeb::Application.nice_map[handle] || 0
    end

    render json: {
      image: image_url || nil,
      niceness: niceness,
      current: queue_track_to_json(queue.current),
      upcoming: upcoming.map { |t| queue_track_to_json(t) },
      history: history.map { |t| queue_track_to_json(t) },
      icecast: IreulWeb::Application.icecast_service.info,
      time: Time.now.utc.iso8601
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
      start_time: t.try(:start_time) # TODO: Calculate time offset
    }
  end
end
