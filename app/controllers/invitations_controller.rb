class InvitationsController < ApplicationController
  before_action :require_user

  def new
    @invitation = Invitation.new
  end 

  def create
    @invitation = Invitation.create(invitation_params.merge!(user_id: current_user.id))

    if @invitation.save
      @invitation.update_attribute(:token, SecureRandom.urlsafe_base64)
      AppMailer.send_invitation(@invitation).deliver
      flash[:success] = "Your invations to #{@invitation.guest_name} has been sent"
      redirect_to invite_friend_path
    else
      render :new
    end
  end

  private

  def invitation_params
    params.require(:invitation).permit(:guest_name, :guest_email, :invitation_message)
  end
end
