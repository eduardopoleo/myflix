class VideoDecorator
  attr_reader :video
  def initialize(video)
     @video = video
  end

  def show_rating
    if video.rating_average
      "Rating: #{video.rating_average}/5.0"
    else
      "No rating available"
    end
  end
end
