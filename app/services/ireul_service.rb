require 'ireul'
require 'socket'

# ALL CALLS TO @IREUL must be wrapped in a @ireul_sema.synchronize call
class IreulService
  include Singleton

  class IreulConnError < StandardError
  end

  attr_accessor :url
  attr_accessor :port
  attr_accessor :username
  attr_accessor :password
  attr_reader :configured

  RETRY_DELAY = 10

  def configure
    yield self if block_given?

    @configured = true
    @ireul_sema = Mutex.new
    @reconnecting_sema = Mutex.new
    @@queue_watcher = nil

    self
  end

  def connect
    Rails.logger.info "[service.ireul] Connecting to Ireul at #{url}:#{port}..."
    @socket = TCPSocket.new(url, port)
    @ireul = Ireul::Core.new(@socket)
    start_queue_watcher
  rescue Errno::ECONNREFUSED => e
    Rails.logger.warn "[service.ireul] Failed to connect to Ireul: starting reconnect...\n#{e.inspect}"
    reconnect
    raise IreulConnError
  end

  def reconnect
    if @reconnecting_sema.try_lock
      Thread.new do
        catch :connected do
          begin
            Rails.logger.info "[service.ireul] Trying reconnect to #{url}:#{port}..."
            @socket = TCPSocket.new(url, port)
            @ireul = Ireul::Core.new(@socket)
            start_queue_watcher
            throw :connected
          rescue
            sleep RETRY_DELAY
            retry
          end
        end

        Rails.logger.info '[service.ireul] Reconnected.'
        @reconnecting_sema.unlock
      end
    end
  end

  def enqueue(song)
    song_buf = open(song.file.path, 'rb').read
    @ireul_sema.synchronize do
      handle = @ireul.enqueue(song_buf)
      IreulWeb::Application.handle_map[handle.value] = song.id
    end
    # TODO: clean handle_map
  end

  private

  def start_queue_watcher
    @@queue_watcher.kill if @@queue_watcher

    IreulWeb::Application.queue_watcher_sema.synchronize do
      Rails.logger.info '[service.ireul] Starting queue watcher...'
      @@queue_watcher = Thread.new do
        loop do
          Rails.logger.info('Checking queue...')

          queue = @ireul_sema.synchronize do
            @ireul.queue_status
          end

          if queue.upcoming.nil? || queue.upcoming.empty?
            # Optimise getting random song
            song = Song.offset(rand(Song.count)).first
            Rails.logger.info "[service.ireul] Queue empty, queuing song #{song.id}..."
            enqueue(song)
          end
          sleep 30
        end
      end
    end
  end

  def handle_conn_error(e)
    Rails.logger.warn "[service.ireul] Failed to connect to Ireul: reconnecting...\n#{e.inspect}"
    Rails.logger.warn "[service.ireul] #{e.backtrace.join("\n")}"
    reconnect
    raise IreulConnError
  end

  def method_missing(method, args = nil)
    raise IreulConnError if @ireul.nil?

    if @ireul.method(method).arity > 0
      @ireul_sema.synchronize { @ireul.send(method, args) }
    else
      @ireul_sema.synchronize { @ireul.send(method) }
    end
  rescue IreulConnError, Errno::ECONNRESET, Errno::ECONNREFUSED, Errno::ECONNABORTED => e
    handle_conn_error(e)
  end
end
