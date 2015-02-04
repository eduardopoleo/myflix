class FollowingsController < ApplicationController 
  before_action :require_user

  def index
    @user = User.find(params[:user_id])
    @followings = @user.followings
  end

  def create
    @following = Following.new(user_id: params[:user_id], subject_id: params[:subject_id]) 

    if @following.save
      flash[:notice] = "Your are now following #{User.find(params[:subject_id]).full_name}"
    else
      flash[:error] = "You already follow that person'"
    end

    redirect_to user_followings_path(current_user)
  end
end
