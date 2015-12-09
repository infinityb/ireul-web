require 'test_helper'

class MetadatumControllerTest < ActionController::TestCase
  class WithAuthorization < MetadatumControllerTest
    setup do
      @metadata = metadata(:metadata_001)
      @field = metadata_fields(:metadata_fields_001)
      @song = songs(:songs_001)
      force_authorize
    end

    test "should get new" do
      get :new, song_id: @song.id
      assert_response :success
    end

    test "should create metadata" do
      assert_difference('Metadatum.count') do
        post :create, metadatum: { song_id: @song.id, metadata_field_id: @field.id, value: "Yayoi" }
      end
      assert_redirected_to @song
    end

    test "should assign artist foreign key of song on create" do
      skip("unimplemented")
    end

    test "should assign title foreign key of song on create" do
      skip("unimplemented")
    end

    test "should get edit" do
      get :edit, id: @metadata
      assert_response :success
    end

    test "should update metadata" do
      patch :update, id: @metadata, metadatum: { value: "Should work" }
      assert_response :redirect
    end

    test "should destroy metadata" do
      assert_difference('Metadatum.count', -1) do
        delete :destroy, id: @metadata
      end
    end
  end

  class WithoutAuthorization < MetadatumControllerTest
    setup do
      @metadata = metadata(:metadata_001)
      @field = metadata_fields(:metadata_fields_001)
      @song = songs(:songs_001)
    end

    test "should not get new without authorization" do
      get :new
      assert_redirected_to login_url
    end

    test "should not create metadata without authorization" do
      assert_no_difference('Metadatum.count') do
        post :create, song: @song, field: @field, value: "This should fail"
      end

      assert_redirected_to login_url
    end

    test "should not get edit without authorization" do
      get :edit, id: @metadata
      assert_redirected_to login_url
    end

    test "should not update metadatum without authorization" do
      patch :update, id: @metadata, value: { value: 'lmao' }
      assert_redirected_to login_url
    end

    test "should not destroy metadatum without authorization" do
      assert_no_difference('Metadatum.count') do
        delete :destroy, id: @metadata
      end

      assert_redirected_to login_url
    end
  end
end
