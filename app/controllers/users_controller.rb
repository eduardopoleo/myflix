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
    response =  UserSignup.new(@user).sign_up(params[:stripeToken],
                                              params[:token])
    if response.status == :success
      flash[:success] = "Thanks for registering with myflix"
      redirect_to signin_path
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
