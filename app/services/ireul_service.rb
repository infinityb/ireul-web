require 'ireul'
require 'socket'

class IreulService
  include Singleton

  class IreulConnError < StandardError
  end

  attr_accessor :url
  attr_accessor :port
  attr_accessor :username
  attr_accessor :password

  RETRY_DELAY = 10

  def configure
    yield self if block_given?
    connect if !@configured
    @configured = true
    self
  end

  def connect
    Rails.logger.info "Connecting to Ireul at #{self.url}:#{self.port}..."
    @socket = TCPSocket::new(self.url, self.port)
    @ireul = Ireul::Core.new(@socket)
  rescue Errno::ECONNREFUSED => e
    Rails.logger.warn "Failed to connect to Ireul: starting reconnect...\n#{e.inspect}"
    reconnect
    raise IreulConnError
  end

  def reconnect
    @reconnecting_sema ||= Mutex.new
    if @reconnecting_sema.try_lock
      Thread.new do
        catch :connected do
          begin
            Rails.logger.info "Trying reconnect to #{self.url}:#{self.port}..."
            @socket = TCPSocket::new(self.url, self.port)
            @ireul = Ireul::Core.new(@socket)
            throw :connected
          rescue
            sleep RETRY_DELAY
            retry
          end
        end

        Rails.logger.info "Reconnected."
        @reconnecting_sema.unlock
      end
    end
  end

  def method_missing(method, args)
    if @ireul.nil?
      raise IreulConnError
    else
      @ireul.send(method, args)
    end
  rescue IreulConnError, Errno::ECONNRESET, Errno::ECONNREFUSED => e
    Rails.logger.warn "Failed to connect to Ireul: reconnecting...\n#{e.inspect}"
    reconnect
    raise IreulConnError
  end
end
