class Following < ActiveRecord::Base
  belongs_to :user
  belongs_to :subject, class_name: "User"
end
