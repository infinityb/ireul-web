require 'socket'
require 'open-uri'
require 'nokogiri'

class IcecastService
  include Singleton

  attr_reader :configured
  attr_reader :info
  attr_accessor :icecast_web_addr
  attr_accessor :mountpoint_selector

  POLL_INTERVAL = 10
  RETRY_INTERVAL = 60

  def configure
    yield self if block_given?
    @configured = true
    self
  end

  def start_polling
    Thread.new do
      begin
        loop do
          Rails.logger.info "[service.icecast] Polling info from Icecast #{@icecast_web_addr}..."
          @info = get_info(@icecast_web_addr)
          Rails.logger.info "[service.icecast] Polled info from Icecast #{@icecast_web_addr}: #{@info}. Sleeping #{POLL_INTERVAL}s..."
          sleep POLL_INTERVAL
        end
      rescue Exception => e
        Rails.logger.error "[service.icecast] Exception occurred while polling Icecast info page. Sleeping #{RETRY_INTERVAL}s..."
        Rails.logger.error e
        Rails.logger.error e.backtrace
        sleep RETRY_INTERVAL
        retry
      end
    end
  end

  # For older Icecast versions. Newer ones have a JSON API.
  def get_info(url)
    doc = Nokogiri::HTML(open(url).read)
    mounts = doc.css('.roundcont')
    mount = mounts.select { |m| m.css('.streamheader h3').text == "Mount Point #{@mountpoint_selector}" }[0]
    listeners = mount.css('.newscontent > table > tr:nth-child(5) > td:nth-child(2)').text
    { time: Time.now.utc, listeners: listeners.to_i }
  end
end
