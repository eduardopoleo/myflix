class Invitation < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :guest_email, :guest_name, :invitation_message
end
