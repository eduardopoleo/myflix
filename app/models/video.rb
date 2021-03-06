class Video < ActiveRecord::Base
  belongs_to :category
  validates_presence_of :title, :description
  has_many :queue_items
  has_many :reviews

  mount_uploader :large_cover, LargeCoverUploader
  mount_uploader :small_cover, SmallCoverUploader

  def self.search_by_title(search_word)
    where('LOWER(title) LIKE ?', "%#{search_word.downcase}%").order('created_at DESC')
  end

  def decorator
    VideoDecorator.new(self)
  end
 
  def rating_average 
    if reviews.size == 0
      nil
    else
      sum = 0
      reviews.each do |review|
        sum += review.rating
      end
      sum/reviews.size
    end
  end  
end
