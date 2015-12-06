require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  test "should not get index without authorization" do
    get :index
    assert_redirected_to login_url
  end
end
