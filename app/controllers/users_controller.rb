class UsersController < ApplicationController
  before_action :require_user, only: [:show]

  def new
    flash[:success] = "To sign up use this card number 4242424242424242 and any security code and a expiration date you wish!" 
    @user = User.new
  end

  def show
    @user = User.find(params[:id])
  end

  def create
    @user = User.new(set_params)
    response =  UserSignup.new(@user).sign_up(params[:stripeToken],
                                              params[:token])
    if response.status == :success
      session[:user_id] = @user.id
      flash[:success] = "Thanks for registering with myflix"
      redirect_to home_path
    else
      flash[:error] = response.error_message
      render :new
    end
  end

  def invited_user
    @token = params[:token]
    invitation =  Invitation.find_by_token(@token)
    @user = User.new(email: invitation.guest_email)
    render :new
  end

  private
  def set_params
    params.require(:user).permit!
  end
end
