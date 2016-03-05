class AdminController < ApplicationController
  def index
    @user = User.find(session[:user_id])
  end

  def restart
    @user = User.find(session[:user_id])
    Dir.mkdir('tmp') unless File.exists?(Rails.root.join('tmp'))
    restart_txt_path = Rails.root.join('tmp', 'restart.txt')
    logger.info "Restart initiated by #{@user && @user.name} (#{@user && @user.id})."
    logger.info "touch-ing ${restart_txt_path}"
    `touch #{restart_txt_path}`

    render 'admin/restart'
  end
end
