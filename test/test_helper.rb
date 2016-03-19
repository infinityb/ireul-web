ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

module ActiveSupport
  class TestCase
    # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
    fixtures :all

    # Add more helper methods to be used by all tests here...
    def force_authorize
      allow_any_instance_of(ApplicationController)
        .to receive(:authorize)
        .and_return(true)
    end

    module ImageHelper
      def get_test_image(filename)
        File.new("test/fixtures/images/#{filename}")
      end

      def get_test_image_upload(filename)
        fixture_file_upload("images/#{filename}", 'image/')
      end
    end

    module AudioHelper
      def get_test_audio(filename)
        File.new("test/fixtures/audio/#{filename}")
      end

      def get_test_audio_upload(filename)
        fixture_file_upload("audio/#{filename}", 'audio/ogg')
      end
    end

    module IreulHelper
      class Mock
        def method_missing(_); end
      end

      class MockIreul
        def enqueue(_); end
        def fast_forward(_); end
        def queue_status; Mock.new; end
      end
    end
  end
end

# rspec/mocks integration with minitest
# https://www.relishapp.com/rspec/rspec-mocks/v/3-2/docs/outside-rspec/integrate-with-minitest
require 'minitest/autorun'
require 'rspec/mocks'

module MinitestRSpecMocksIntegration
  include ::RSpec::Mocks::ExampleMethods

  def before_setup
    ::RSpec::Mocks.setup
    super
  end

  def after_teardown
    super
    ::RSpec::Mocks.verify
  ensure
    ::RSpec::Mocks.teardown
  end
end

Minitest::Test.send(:include, MinitestRSpecMocksIntegration)
