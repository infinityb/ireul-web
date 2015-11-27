require 'test_helper'

class RadioControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should skip song" do
    skip("figure out how to stub sockets in MiniTest")
    get :skip
    assert_response :success
  end
end
