class AppMailer < ActionMailer::Base
  def welcome_email(user)
    @user = user
    mail from: 'eduardopoleo@gmail.com', to: @user.email, subject: "Welcome to Myflix!"
  end

  def send_forgot_password(user)
    @user = user
    mail to: user.email, from: "info@myflix.com", subject: "Please reset your password"
  end 

  def send_invitation(invitation) 
    @token = invitation.token
    @user =  invitation.user
    @guest_name = invitation.guest_name
    @message = invitation.invitation_message
    mail to: invitation.guest_email, from:"info@myflix.com", subject: "Myflix Invitation"
  end
end
