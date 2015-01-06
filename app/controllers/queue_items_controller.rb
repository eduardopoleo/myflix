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

  def destroy
    item = QueueItem.find(params[:id])
    item.destroy if current_user.queue_items.include?(item)
    normalize_queue_items_order
    redirect_to queue_items_path
  end

  def update_queue
    begin
      update_queue_items    
      normalize_queue_items_order
    rescue ActiveRecord::RecordInvalid
      flash[:error]='Invalid position number'
    end
    redirect_to queue_items_path
  end

  private
  #These are method that can not actually be routed.
  def queue_items_count
    current_user.queue_items.count + 1
  end

  def repeated_video?(video)
    current_user.queue_items.map(&:video).include?(video)
  end

  def update_queue_items
    ActiveRecord::Base.transaction do
      params[:queue_items].each do |item| 
        modified_item = QueueItem.find(item[:id])
        modified_item.update_attributes!(order: item[:order]) if modified_item.user == current_user
      end
    end
  end

  def normalize_queue_items_order
    current_user.queue_items.each_with_index do |queue_item, index| 
      queue_item.update_attributes(order: index + 1)
    end
  end
end
