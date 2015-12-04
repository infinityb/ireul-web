ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  module ImageHelper
    def get_test_image(filename)
      File.new("test/fixtures/images/#{filename}")
    end

    def get_test_image_upload(filename)
      fixture_file_upload("images/#{filename}", "image/")
    end
  end

  module AudioHelper
    def get_test_audio(filename)
      File.new("test/fixtures/audio/#{filename}")
    end

    def get_test_audio_upload(filename)
      fixture_file_upload("audio/#{filename}", "audio/ogg")
    end
  end
end
