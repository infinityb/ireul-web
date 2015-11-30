require 'ireul'
require 'socket'

class IreulService
  attr_accessor :url
  attr_accessor :port
  attr_accessor :username
  attr_accessor :password

  @socket = nil
  @ireul = nil

  MAX_RETRIES = :infinite
  RETRY_DELAY = 10

  def initialize
    yield self if block_given?
  end

  def connect
    Rails.logger.info "Connecting to Ireul at #{self.url}:#{self.port}..."
    @socket = TCPSocket::new(self.url, self.port)
    @ireul = Ireul::Core.new(@socket)
  rescue Errno::ECONNREFUSED => e
    Rails.logger.warn "Failed to connect to Ireul: starting reconnect...\n#{e.inspect}"
    reconnect
  end

  def reconnect
    retries = 0

    catch :connected do
      begin
        Rails.logger.info "Starting reconnect try #{retries + 1}..."
        @socket = TCPSocket::new(self.url, self.port)
        @ireul = Ireul::Core.new(@socket)
        Rails.logger.info "Reconnected."
        throw :connected
      rescue
        if MAX_RETRIES != :infinite && retries > MAX_RETRIES
          throw Exception("Failed to connect to Ireul: max retries reached (#{MAX_RETRIES}")
        else
          retries += 1
          sleep RETRY_DELAY
          retry
        end
      end
    end
  end

  def method_missing(method, args)
    @ireul.send(method, args)
  rescue Errno::ECONNRESET, Errno::ECONNREFUSED => e
    Rails.logger.warn "Failed to connect to Ireul: reconnecting...\n#{e.inspect}"
    reconnect
  end
end
