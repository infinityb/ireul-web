require 'test_helper'

class RadioControllerTest < ActionController::TestCase
  class WithAuthorization < RadioControllerTest
    setup do
      @song = songs(:songs_001)
      allow_any_instance_of(ApplicationController)
        .to receive(:authorize)
        .and_return(true)
    end

    test "should get index" do
      get :index
      assert_response :success
    end

    test "should skip song" do
      skip("unimplemented")
    end

    test "should request song" do
      skip("unimplemented")
    end

    test "should enqueue song" do
      skip("unimplemented")
    end

    test "should return info" do
      skip("unimplemented")
    end
  end

  class WithoutAuthorization < RadioControllerTest
    setup do
      @song = songs(:songs_001)
    end

    test "should not skip song without authorization" do
      skip("unimplemented")
    end

    test "should request song without authorization" do
      skip("unimplemented")
    end

    test "should not enqueue song without authorization" do
      skip("unimplemented")
    end

    test "should not return info without authorization" do
      skip("unimplemented")
    end
  end
end
