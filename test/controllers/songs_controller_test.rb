require 'test_helper'

class SongsControllerTest < ActionController::TestCase
  setup do
    @song = songs(:songs_001)
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

  test "should create song" do
    skip("obtain test ogg for this")
    assert_difference('Song.count') do
      post :create, song: {  }
    end

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
    skip("obtain test ogg for this")
    patch :update, id: @song, song: { artist_id: @song.artist_id, title: @song.title }
    assert_redirected_to song_path(assigns(:song))
  end

  test "should destroy song" do
    song_id = @song.id

    assert(Metadatum.where(song_id: song_id).count > 0)

    assert_difference('Song.count', -1) do
      delete :destroy, id: @song
    end

    assert(Metadatum.where(song_id: song_id).count == 0)

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

    expected_songs = [{
      "id" => @song.id,
      "artist" => @song.artist,
      "title" => @song.title
    }].to_json

    assert_equal expected_songs, JSON.parse(@response.body)["results"].to_json
  end
end
