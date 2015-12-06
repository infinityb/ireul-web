require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  class WithAuthorization < UsersControllerTest
    setup do
      @input_attributes = {
        name: "owls",
        password: "letmein",
        password_confirmation: "letmein"
      }
      @user = users(:one)
      force_authorize
    end

    test "should get index" do
      get :index
      assert_response :success
      assert_not_nil assigns(:users)
    end

    test "should get new" do
      get :new
      assert_response :success
    end

    test "should create user" do
      assert_difference('User.count') do
        post :create, user: @input_attributes
      end

      assert_redirected_to users_path
    end

    test "should show user" do
      get :show, id: @user
      assert_response :success
    end

    test "should get edit" do
      get :edit, id: @user
      assert_response :success
    end

    test "should update user" do
      patch :update, id: @user, user: @input_attributes
      assert_redirected_to users_path
    end

    test "should destroy user" do
      assert_difference('User.count', -1) do
        delete :destroy, id: @user
      end

      assert_redirected_to users_path
    end
  end

  class WithoutAuthorization < UsersControllerTest
    setup do
      @user = users(:one)
    end

    test "should not get index without authorization" do
      get :index
      assert_redirected_to login_url
    end

    test "should not get new without authorization" do
      get :new
      assert_redirected_to login_url
    end

    test "should not create user without authorization" do
      assert_no_difference('User.count') do
        post :create, user: {}
      end

      assert_redirected_to login_url
    end

    test "should not show user without authorization" do
      get :show, id: @user
      assert_redirected_to login_url
    end

    test "should not get edit without authorization" do
      get :edit, id: @user
      assert_redirected_to login_url
    end

    test "should not update user without authorization" do
      patch :update, id: @user, user: @input_attributes
      assert_redirected_to login_url
    end

    test "should not destroy user without authorization" do
      assert_no_difference('User.count') do
        delete :destroy, id: @user
      end

      assert_redirected_to login_url
    end
  end
end
