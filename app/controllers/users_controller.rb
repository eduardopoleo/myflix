class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(set_params)

    if @user.save
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
