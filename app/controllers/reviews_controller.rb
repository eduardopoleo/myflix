class ReviewsController < ApplicationController
  before_action :require_user

  def create
    @video = Video.find(params[:video_id])
    @review = @video.reviews.build(review_params.merge!(user: current_user))
    #This would be equivlent of saying
    #@review = Review.new(review_params)
    #@review.video = @video
    #@review.user = current_user 
    # The build shortens the assotiation and the merge! just mergers the params
    
    if @review.save 
      redirect_to @video
    else
      # reloads the review from the database
      # this throws away the invalid review appended to videos
      @reviews = @video.reviews.reload
      render 'videos/show'
    end
  end

  private
  def review_params
    params.require(:review).permit(:rating, :content)
  end
end
