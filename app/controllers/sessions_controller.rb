class SessionsController < ApplicationController
  def new
    if logged_in?
      redirect_to home_path
    end
  end

  def create
    user = User.where(email: params[:email]).first

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to home_path, notice: 'You are signed in, enjoy!'
    else
      flash[:error] = "Email or password do not match"
      redirect_to signin_path
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end
end