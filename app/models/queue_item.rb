class QueueItem < ActiveRecord::Base
  belongs_to :video
  belongs_to :user
  validates :video_id, presence: true
  validates_numericality_of :order, {only_integer: true}
 
  def display_title 
    video.title 
  end

  def display_genre
    video.category.title
  end

  def rating
    review = Review.where(user_id: user.id, video_id: video.id).first
    review.rating if review
  end
end
