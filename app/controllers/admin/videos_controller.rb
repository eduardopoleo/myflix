class Admin::VideosController < ApplicationController
  before_action :require_user
  before_action :require_admin

  def new
    @video = Video.new
  end

  def create
    @video = Video.create(video_params)

    if @video.save
      flash[:success] = "You have successfully created the video #{@video.title}"
      redirect_to new_admin_videos_path
    else
      flash[:error] = "You video could not be created"
      render :new
    end
  end


  private

  def video_params
    params.require(:video).permit(:title, :category_id, :description, :small_cover, :large_cover, :video_url)
  end 
  
  def require_admin
    if !current_user.admin?
      flash[:error] = 'Sorry but you are not authorized to do that.'
      redirect_to home_path
    end
  end
end
