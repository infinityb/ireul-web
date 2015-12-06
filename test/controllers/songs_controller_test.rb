require 'test_helper'
require 'rspec/mocks'

class SongsControllerTest < ActionController::TestCase
  include AudioHelper
  include ImageHelper

  class WithAuthorization < SongsControllerTest
    setup do
      @song = songs(:songs_001)
      allow_any_instance_of(ApplicationController)
        .to receive(:authorize)
        .and_return(true)
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:songs)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create song with metadata" do
      file = get_test_audio_upload("busysignal.ogg")

      assert_difference('Song.count') do
        post :create, song: { file: file }
      end

      metadatum = Metadatum.where(song: assigns(:song))
      artist_field_id = MetadataField.where(name: "ARTIST")
      artist_record = metadatum.where(metadata_field_id: artist_field_id).first
      assert_equal(artist_record.value, "Aibi")

      title_field_id = MetadataField.where(name: "TITLE")
      title_record = metadatum.where(metadata_field_id: title_field_id).first
      assert_equal(title_record.value, "Busy Signal")

      assert_redirected_to song_path(assigns(:song))
    end

    test "should create song with uploaded image" do
      audio_file = get_test_audio_upload("busysignal.ogg")
      image_file = get_test_image_upload("a.jpg")

      assert_difference('Song.count') do
        assert_difference('BackgroundImage.count') do
          post :create, song: { file: audio_file }, background_image: { image: image_file }
        end
      end

      assert_equal(assigns(:image).song, assigns(:song))

      assert_redirected_to song_path(assigns(:song))
    end

    test "should show song" do
      get :show, id: @song
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @song
      assert_response :success
    end

    test "should update song" do
      file = get_test_audio_upload("busysignal.ogg")

      patch :update, id: @song, song: { file: file }
      assert_redirected_to song_path(assigns(:song))
    end

    test "should destroy song" do
      song_id = @song.id

      assert(Metadatum.where(song_id: song_id).count > 0)
      assert(BackgroundImage.where(song_id: song_id).count > 0)

      assert_difference('Song.count', -1) do
        delete :destroy, id: @song
      end
      assert(Metadatum.where(song_id: song_id).count == 0)
      assert(BackgroundImage.where(song_id: song_id).count == 0)

      assert_redirected_to songs_path
    end

    test "should search songs" do
      post :search, query: @song.title
      assert_equal assigns(:songs)[0].title, @song.title
      assert_response :success
    end

    test "should search songs and give a json response" do
      post :search, query: @song.title, format: 'json'
      assert_response :success

      json_parsed = JSON.parse(JSON.parse(@response.body)["results"].to_json)[0]

      assert_equal @song.id, json_parsed["id"]
      assert_equal @song.artist, json_parsed["artist"]
      assert_equal @song.title, json_parsed["title"]
      refute_empty json_parsed["canRequestAt"]
    end
  end

  class WithoutAuthorization < SongsControllerTest
    setup do
      @song = songs(:songs_001)
    end

    test "should not get index.html without authorization" do
      get :index
      assert_redirected_to login_url
    end

    test "should get index.json without authorization" do
      get :index, format: 'json'
      assert_response :success
    end

    test "should not get new without authorization" do
      get :new
      assert_redirected_to login_url
    end

    test "should not create song without authorization" do
      assert_no_difference('Song.count') do
        post :create, song: { file: nil }
      end

      assert_redirected_to login_url
    end

    test "should not show song without authorization" do
      get :show, id: @song
      assert_redirected_to login_url
    end

    test "should not get edit without authorization" do
      get :edit, id: @song
      assert_redirected_to login_url
    end

    test "should not update song without authorization" do
      patch :update, id: @song, song: { file: nil }
      assert_redirected_to login_url
    end

    test "should not destroy song without authorization" do
      assert_no_difference('Song.count') do
        delete :destroy, id: @song
      end
      assert_redirected_to login_url
    end

    test "should not get search.html without authorization" do
      post :search, query: @song.title
      assert_redirected_to login_url
    end

    test "should search songs and give a json response without authorization" do
      post :search, query: @song.title, format: 'json'
      assert_response :success

      json_parsed = JSON.parse(JSON.parse(@response.body)["results"].to_json)[0]

      assert_equal @song.id, json_parsed["id"]
      assert_equal @song.artist, json_parsed["artist"]
      assert_equal @song.title, json_parsed["title"]
      refute_empty json_parsed["canRequestAt"]
    end
  end
end
