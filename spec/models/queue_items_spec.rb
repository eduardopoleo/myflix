require 'spec_helper'

describe QueueItem do 
  it {should belong_to(:video)}
  it {should belong_to(:user)}

  describe '#display__title' do
    it 'displays the title of the video associated' do
      video = Fabricate(:video)
      queue_item = QueueItem.create(video_id: video.id)
      expect(queue_item.display_title).to eq(video.title)
    end
  end

  describe '#show_genre' do
    it 'displays the video category' do
      category = Fabricate(:category)
      video = Fabricate(:video, category: category)
      queue_item = QueueItem.create(video: video)
      expect(queue_item.display_genre).to eq(video.category.title)
    end
  end

  describe '#rating' do
    it 'display the rating of the associated video review if the review exist' do
      user = Fabricate(:user)
      video = Fabricate(:video)
      review = Fabricate(:review, video: video, user: user, rating: 4)
      queue_item = Fabricate(:queue_item, video: video, user: user) 
      expect(queue_item.rating).to eq(4)
    end

    it 'return nil when there is no review' do
      user = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video, user: user) 
      expect(queue_item.rating).to eq(nil)
    end
  end
end
