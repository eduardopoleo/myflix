class UserSignup 
  attr_accessor :user, :status, :error_message

  def initialize(user)
    @user = user
  end 

  def sign_up(stripe_token, invitation_token)
    if user.valid?
      customer = StripeWrapper::Customer.create(
        :user => @user,
        :card => stripe_token
      )

      if customer.successful?
        @user.customer_token = customer.customer_token
        user.save
        handle_invitation(invitation_token)
        AppMailer.delay.welcome_email(user)
        @status = :success
        self
      else
        @status = :failed
        @error_message = customer.error
        self
      end
    else
      @status = :failed
      @error_message = "Invalid user information plese try again."
      self
    end
  end

  private
  def handle_invitation(invitation_token)
    if invitation_token.present?
      invitation = Invitation.where(token: invitation_token).first
      invitation.user.subjects << @user
      @user.subjects << invitation.user
      invitation.update_attribute(:token, nil)
    end
  end
end
