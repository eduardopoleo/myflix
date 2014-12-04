require 'spec_helper'

describe Category do
  it {should have_many(:videos)}

  describe '#recent_videos' do
    category = Category.create(title: 'category')

    it 'returns a list of videos sorted chronologically by the creation date' do
      video1 = Video.create(title: 'First Video', description: 'This is the first video', category: category, created_at: 2.day.ago)
      video2 = Video.create(title: 'Second Video', description: 'This is the second video', category: category, created_at: 1.day.ago)
      video3 = Video.create(title: 'Third Video', description: 'This is the third video', category: category)

      expect(category.recent_videos).to eq([video3,video2,video1])
    end

    it 'returns the number of videos if it is less than 6' do
      video1 = Video.create(title: 'First Video', description: 'This is the first video', category: category, created_at: 2.day.ago)
      video2 = Video.create(title: 'Second Video', description: 'This is the second video', category: category, created_at: 1.day.ago)
      video3 = Video.create(title: 'Third Video', description: 'This is the third video', category: category)

      expect(category.recent_videos.size).to eq(3)
    end

    it 'returns only 6 videos if the number is more than 6' do
      video1 = Video.create(title: 'First Video', description: 'This is the first video', category: category, created_at: 1.day.ago)
      video2 = Video.create(title: 'First Video', description: 'This is the first video', category: category, created_at: 2.day.ago)
      video3 = Video.create(title: 'First Video', description: 'This is the first video', category: category, created_at: 3.day.ago)
      video4 = Video.create(title: 'First Video', description: 'This is the first video', category: category, created_at: 4.day.ago)
      video5 = Video.create(title: 'First Video', description: 'This is the first video', category: category, created_at: 5.day.ago)
      video6 = Video.create(title: 'First Video', description: 'This is the first video', category: category, created_at: 6.day.ago)
      video7 = Video.create(title: 'First Video', description: 'This is the first video', category: category, created_at: 7.day.ago)
      video8 = Video.create(title: 'First Video', description: 'This is the first video', category: category, created_at: 8.day.ago)
      video9 = Video.create(title: 'First Video', description: 'This is the first video', category: category, created_at: 9.day.ago)
      video10 = Video.create(title: 'First Video', description: 'This is the first video', category: category, created_at: 10.day.ago)
      expect(category.recent_videos).to eq([video1,video2,video3,video4,video5,video6])
    end

    it 'returns [] if there are no videos' do
      expect(category.recent_videos).to eq([])
    end

  end
end