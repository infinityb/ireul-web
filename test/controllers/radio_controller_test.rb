require 'test_helper'

class RadioControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
