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
    review.rating if review
  end

  def rating=(new_rating)
    if review
      review.update_column(:rating, new_rating)
    else
      review = Review.new(user: user, video: video, rating: new_rating)
      review.save(validate: false)
    end
  end

  private
  def review
    @review ||= Review.where(user_id: user.id, video_id: video.id).first
  end
end
