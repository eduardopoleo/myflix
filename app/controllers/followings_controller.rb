class FollowingsController < ApplicationController 
  before_action :require_user

  def index
    @user = User.find(params[:user_id])
    @followings = @user.followings
  end

  def create
    @following = current_user.followings.build(subject_id: params[:subject_id]) 
    if !same_user?(@following)
      if @following.save
        flash[:notice] = "Your are now following #{subject_name(@following)}"
      else
        flash[:error] = "You are already following #{subject_name(@following)}"
      end
    else
      flash[:error] = "You can't follow yourself"
    end
    redirect_to user_followings_path(current_user)
  end

  def destroy
    @following = Following.find(params[:id])
    if current_user_owns_following?(@following)
      flash[:notice] = "You are not longer following #{subject_name(@following)}"
      @following.destroy
    else
      flash[:notice] = "You can't delete a following you do not own' "
    end
    redirect_to user_followings_path(current_user)
  end

  private
  def subject_name(following)
    following.subject.full_name 
  end

  def current_user_owns_following?(following)
    current_user == following.user
  end

  def same_user?(following)
    current_user == following.subject
  end
end
