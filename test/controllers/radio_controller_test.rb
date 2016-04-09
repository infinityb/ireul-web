require 'test_helper'

class RadioControllerTest < ActionController::TestCase
  class WithAuthorization < RadioControllerTest
    include IreulHelper

    setup do
      @song = songs(:songs_001)
      allow_any_instance_of(ApplicationController)
        .to receive(:authorize)
        .and_return(true)
      allow_any_instance_of(Song)
        .to receive(:find)
        .and_return(@song)
      allow(IreulWeb::Application)
        .to receive(:ireul_client)
        .and_return(MockIreul.new)
    end

    test 'should get index' do
      get :index
      assert_response :success
    end

    test 'should skip song' do
      post :skip
      assert_response :success
    end

    test 'should request song' do
      post :request_song, id: 1
      assert_response :success
    end

    test 'should enqueue song' do
      post :enqueue, id: 1
      assert_response :success
    end

    test 'should return info' do
      get :info
      assert_response :success
    end

    test 'should nice' do
      allow(NilClass).to receive(:handle)
      post :nice
      assert_response :success
    end

    test 'should increase niceness value' do
      skip 'unimplemented'
    end

    test 'should increase niceness value only once for an IP per song' do
      skip 'unimplemented'
    end
  end

  class WithoutAuthorization < RadioControllerTest
    include IreulHelper

    setup do
      @song = songs(:songs_001)
      allow(IreulWeb::Application)
        .to receive(:ireul_client)
        .and_return(MockIreul.new)
    end

    test 'should not skip song without authorization' do
      post :skip
      assert_response :redirect
    end

    test 'should request song without authorization' do
      post :request_song, id: 1
      assert_response :success
    end

    test 'should not enqueue song without authorization' do
      post :enqueue, id: 1
      assert_response :redirect
    end

    test 'should return info without authorization' do
      get :info
      assert_response :success
    end

    test 'should nice without authorization' do
      allow(NilClass).to receive(:handle)
      post :nice
      assert_response :success
    end
  end
end
