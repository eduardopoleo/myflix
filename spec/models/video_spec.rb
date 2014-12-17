require 'spec_helper'

describe Video do
  it {should belong_to(:category)}
  it {should validate_presence_of(:title)}
  it {should validate_presence_of(:description)}
  it {should have_many(:reviews)}
  
  describe '#search_by_title' do
    it 'should return an empty array if search word is not found' do
      expect(Video.search_by_title('hello')).to eq([])
    end

    it 'should return a video object whose title contains the exact search word' do
      monk = Video.create(title: 'Monk', description: 'Police action movies parody')
      expect(Video.search_by_title('Monk')).to eq([monk])
    end

    it 'should return the video for a partial match' do
      monk = Video.create(title: 'Monk', description: 'Police action movies parody')
      expect(Video.search_by_title('onk')).to eq([monk])
    end

    it 'should return an array of videos containing the search word' do
      monk = Video.create(title: 'Monk', description: 'Police action movies parody')
      monk1 = Video.create(title: 'Monk and me', description: 'Police action movies parody')
      expect(Video.search_by_title('Monk')).to eq([monk1, monk])
    end
     
    it 'should return and array of videos that contain the search word even if the letter case if different' do
      monk = Video.create(title: 'Monk', description: 'Police action movies parody')
      monk1 = Video.create(title: 'Monk and me', description: 'Police action movies parody')
      expect(Video.search_by_title('monk')).to eq([monk1, monk])
    end
  end
  
  describe '#rating_average' do
    it 'returns nil if the video has no review' do
      video = Fabricate(:video)
      expect(video.rating_average).to eq(nil)
    end
    it 'returns the review rate if the video has only one review' do
      video = Fabricate(:video)
      video.reviews << [Fabricate(:review, rating: 3)]
      expect(video.rating_average).to eq(3)
    end
    it 'returns the average rate if the video has many reviews' do
      video = Fabricate(:video)
      5.times{video.reviews << Fabricate(:review, rating:2)}
      expect(video.rating_average).to eq(2)
    end
  end
end
