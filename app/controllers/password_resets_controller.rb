class PasswordResetsController < ApplicationController
  def show
   user = User.where(token: params[:id]).first
    if user
      @token = user.token
    else
      redirect_to expired_token_path unless user 
    end
  end

  def create
    user = User.where(token: params[:token]).first
    if user
      user.password = params[:password]
      user.generate_token
      user.save
      flash[:notice] = "Your password has been reset"
      redirect_to signin_path
    else
      redirect_to expired_token_path
    end
  end
end
