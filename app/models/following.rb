class Following < ActiveRecord::Base
  belongs_to :user
  belongs_to :subject, class_name: "User"
  validates_uniqueness_of :user, scope: :subject
end
