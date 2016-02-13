require 'test_helper'

class BackgroundImagesControllerTest < ActionController::TestCase
  include ImageHelper

  class WithAuthorization < BackgroundImagesControllerTest
    setup do
      @image = background_images(:background_images_001)
      @image_file = get_test_image_upload('a.jpg')
      @song = songs(:songs_001)
      force_authorize
    end

    test 'should get new' do
      get :new, song_id: @song.id
      assert_response :success
    end

    test 'should create background image' do
      assert_difference('BackgroundImage.count') do
        post :create, background_image: { song_id: @song.id, image: @image_file }
      end
      assert_redirected_to @song
    end

    test 'should not create background image with empty image' do
      assert_no_difference('BackgroundImage.count') do
        post :create, background_image: { song_id: @song.id, image: nil }
      end
      assert_template :new
    end

    test 'should destroy background image' do
      assert_difference('BackgroundImage.count', -1) do
        delete :destroy, id: @image
      end
    end
  end

  class WithoutAuthorization < BackgroundImagesControllerTest
    setup do
      @image = background_images(:background_images_001)
      @image_file = get_test_image_upload('a.jpg')
      @song = songs(:songs_001)
    end

    test 'should not get new without authorization' do
      get :new
      assert_redirected_to login_url
    end

    test 'should not create background iamge without authorization' do
      assert_no_difference('BackgroundImage.count') do
        post :create, song: @song, file: @image_file
      end
      assert_redirected_to login_url
    end

    test 'should not destroy BackgroundImages without authorization' do
      assert_no_difference('BackgroundImage.count') do
        delete :destroy, id: @image
      end
      assert_redirected_to login_url
    end
  end
end
