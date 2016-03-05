require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  class WithAuthorization < AdminControllerTest
    setup do
      @user = users(:one)
      session[:user_id] = @user.id
      force_authorize
    end

    test 'should get index with authorization' do
      get :index
      assert_template :index
    end

    test 'post restart should redirect to restart' do
      post :restart
      assert_template 'admin/restart'
    end

    test 'post restart should touch restart.txt' do
      restart_txt_path = Rails.root.join('tmp', 'restart.txt')
      File.delete(restart_txt_path) if File.exists?(restart_txt_path)
      post :restart
      assert File.exists?(restart_txt_path)
    end
  end

  class WithoutAuthorization < AdminControllerTest
    test 'should not get index without authorization' do
      get :index
      assert_redirected_to login_url
    end

    test 'should not post restart without authorization' do
      post :restart
      assert_redirected_to login_url
    end
  end
end
