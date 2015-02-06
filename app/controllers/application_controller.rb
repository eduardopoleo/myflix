class ApplicationController < ActionController::Base
  protect_from_forgery

  helper_method :current_user, :logged_in?, :queue_item_exist?

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_user
    if !logged_in?
      flash[:error] = "Access reserved for members only please sign in!"
      redirect_to signin_path
    end
  end

  def queue_item_exist?(user_id, video_id)
    QueueItem.where(user_id: user_id, video_id: video_id).exists?
  end 
end
