class User < ActiveRecord::Base
  include Tokenable
  validates_presence_of :email, :password, :full_name
  validates_uniqueness_of :email
  has_secure_password validations: false
  has_many :reviews
  has_many :queue_items, -> { order(:order) }
  has_many :followings, -> { order('created_at desc') }
  has_many :subjects, through: :followings
  has_many :invitations
  has_many :payments
  
  def admin?
    admin
  end

  def deactivate!
    update_attribute(:active, false)
  end

  def queue_items_count
    queue_items.count + 1
  end

  def repeated_video?(video)
    queue_items.map(&:video).include?(video)
  end

  def normalize_queue_items_order
    queue_items.each_with_index do |queue_item, index| 
      queue_item.update_attributes(order: index + 1)
    end
  end
end
