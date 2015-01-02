class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items     
  end

  def create
    video = Video.find(params[:video_id])
    QueueItem.create(video: video, user_id: current_user.id, order: queue_items_count) unless repeated_video?(video) 
    redirect_to queue_items_path
  end

  private
  def queue_items_count
    current_user.queue_items.count + 1
  end

  def repeated_video?(video)
    current_user.queue_items.map(&:video).include?(video)
  end
end
