require 'ireul'
require 'socket'

class IreulService
  attr_accessor :url
  attr_accessor :port
  attr_accessor :username
  attr_accessor :password

  @socket = nil
  @ireul = nil

  def initialize
    yield self if block_given?
  end

  def connect
    @socket = TCPSocket::new(self.url, self.port)
    @ireul = Ireul::Core.new(@socket)
  end

  def method_missing(method, args)
    @ireul.send(method, args)
  end
end
