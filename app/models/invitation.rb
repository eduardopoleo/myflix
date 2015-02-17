class Invitation < ActiveRecord::Base
  include Tokenable
  belongs_to :user
  validates_presence_of :guest_email, :guest_name, :invitation_message
end
