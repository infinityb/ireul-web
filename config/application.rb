require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module IreulWeb
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    config.x.ireul = Rails.application.config_for(:ireul)

    # Storing it here instead of inside IreulService
    # It seemed it was getting wiped inside Ireul every few minutes and I didn't know why
    # Maybe the Rails dev env loader was doing something weird?
    attr_accessor :handle_map
    attr_accessor :queue_watcher_sema
    self.handle_map = {}
    self.queue_watcher_sema = Mutex.new

    # Nice counts are transient for now
    attr_accessor :nice_map
    attr_accessor :nice_voted_ips
    self.nice_map = {}
    self.nice_voted_ips = {}

    attr_accessor :nice_logger
    self.nice_logger = Logger.new("#{Rails.root}/log/#{Rails.env}.nice.log")
    self.nice_logger.info '[radio.nice] Nice log started.'

    def self.ireul_client
      unless IreulService.instance.configured
        IreulService.instance.configure do |i|
          i.url      = config.x.ireul['url']
          i.port     = config.x.ireul['port']
          i.username = config.x.ireul['username']
          i.password = config.x.ireul['password']
        end

        IreulService.instance.connect
      end

      IreulService.instance
    end

    # Pretty bad design here, this shouldn't be a Singleton
    def self.icecast_service
      unless IcecastService.instance.configured
        IcecastService.instance.configure do |i|
          i.icecast_web_addr = config.x.ireul['icecast']['web_addr']
          i.mountpoint_selector = config.x.ireul['icecast']['selector']
        end

        IcecastService.instance.start_polling
      end

      IcecastService.instance
    end

    Paperclip.options[:content_type_mappings] = { ogg: ['application/ogg', 'audio/x-vorbis+ogg'] }
  end
end
