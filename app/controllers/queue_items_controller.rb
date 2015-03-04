class QueueItemsController < ApplicationController
  before_action :require_user

  def index
    @queue_items = current_user.queue_items     
  end

  def create
    video = Video.find(params[:video_id])
    QueueItem.create(video: video, user_id: current_user.id, order: current_user.queue_items_count) unless current_user.repeated_video?(video) 
    redirect_to queue_items_path
  end

  def destroy
    item = QueueItem.find(params[:id])
    item.destroy if current_user.queue_items.include?(item)
    current_user.normalize_queue_items_order
    redirect_to queue_items_path
  end

  def update_queue
    begin
     update_queue_items    
     current_user.normalize_queue_items_order
    rescue ActiveRecord::RecordInvalid
      flash[:error]='Invalid position number'
    end
    redirect_to queue_items_path
  end

  private
  def update_queue_items
    ActiveRecord::Base.transaction(requires_new: true) do
      params[:queue_items].each do |item| 
        modified_item = QueueItem.find(item[:id])
        modified_item.update_attributes!(order: item[:order], rating: item[:rating]) if modified_item.user == current_user
      end
    end
  end
end
