class AppMailer < ActionMailer::Base
  def welcome_email(user)
    @user = user
    mail from: 'eduardopoleo@gmail.com', to: @user.email, subject: "Welcome to Myflix!"
  end

  def send_forgot_password(user)
    @user = user
    mail to: user.email, from: "info@myflix.com", subject: "Please reset your password"
  end 
end
