class InvitationsController < ApplicationController
  before_action :require_user

  def new
    @invitation = Invitation.new
  end 

  def create
    @invitation = Invitation.create(invitation_params.merge!(user_id: current_user.id))

    if @invitation.save
      AppMailer.delay.send_invitation(@invitation)
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
