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
    if @user.valid?
      handle_invitation
      charge = StripeWrapper::Charge.create( :card => params[:stripeToken], :amount => 999, :description => "Payment for #{@user.email}" )
      if charge.successful?
        @user.save
        AppMailer.delay.welcome_email(@user)
        redirect_to home_path
      else
        flash[:error] = charge.error
        return redirect_to register_path
      end
    else
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
  
  def handle_invitation
    if params[:token]
      setup_user_guest_followings
    end
  end

  def set_params
    params.require(:user).permit!
  end

  def setup_user_guest_followings
    invitation = Invitation.where(token: params[:token]).first
    invitation.user.subjects << @user
    @user.subjects << invitation.user
    invitation.update_attribute(:token, nil)
  end
end
