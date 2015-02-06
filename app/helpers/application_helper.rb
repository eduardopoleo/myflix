module ApplicationHelper
  def options_for_video_rating
    [['1 Star', 1], ['2 Stars', 2], ['3 Stars', 3],['4 Stars', 4],['5 Stars', 5]]
  end  

  def number_of_followers(user)
    Following.where(subject_id: user.id).size
  end
end
