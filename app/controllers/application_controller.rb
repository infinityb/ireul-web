class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :authorize
  before_action :set_start_time

  protected

  def authorize
    unless User.find_by_id(session[:user_id])
      redirect_to login_url, notice: 'Employee, please log in before performing work'
    end
  end

  # Used to work around conditional skipping of authorize, see songs_controller
  def authorize2
    authorize
  end

  def set_start_time
    @start_time = Time.now.to_f
  end
end
