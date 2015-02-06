class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(set_params)
    if @user.save
      AppMailer.welcome_email(@user).deliver
      redirect_to home_path
    else
      render :new
    end
  end

  private
  def set_params
    params.require(:user).permit!
  end
end
