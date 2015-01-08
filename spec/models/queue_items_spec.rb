require 'spec_helper'

describe QueueItem do 
  it {should belong_to(:video)}
  it {should belong_to(:user)}
  it {should validate_numericality_of(:order).only_integer}

  describe '#display__title' do
    it 'displays the title of the video associated' do
      video = Fabricate(:video)
      queue_item = QueueItem.create(video_id: video.id)
      expect(queue_item.display_title).to eq(video.title)
    end
  end

  describe '#display_genre' do
    it 'shows the category title' do
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
      queue_item = Fabricate(:queue_item, video: video, user: user, order: 2) 
      expect(queue_item.rating).to eq(4)
    end

    it 'return nil when there is no review' do
      user = Fabricate(:user)
      video = Fabricate(:video)
      queue_item = Fabricate(:queue_item, video: video, user: user, order: 1)
      expect(queue_item.rating).to eq(nil)
    end
  end

  describe '#rating='do
    it 'changes the review rating if the review is present' do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, user: user, video: video, rating: 2)

      queue_item = Fabricate(:queue_item, user: user, video: video)
      queue_item.rating = 4
      expect(Review.first.rating).to eq(4)
    end

    it 'clears the rating if the review is present' do
      video = Fabricate(:video)
      user = Fabricate(:user)
      review = Fabricate(:review, user: user, video: video, rating: 2)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      queue_item.rating = nil 
      expect(Review.first.rating).to be_nil
    end

    it 'creates the review if the review is present'do
      video = Fabricate(:video)
      user = Fabricate(:user)
      queue_item = Fabricate(:queue_item, user: user, video: video)
      queue_item.rating = 4 
      expect(Review.first.rating).to eq(4)
    end
  end
end
