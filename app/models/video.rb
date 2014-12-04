class Video < ActiveRecord::Base
  belongs_to :category
  validates_presence_of :title, :description

  def self.search_by_title(search_word)
    where('LOWER(title) LIKE ?', "%#{search_word.downcase}%").order('created_at DESC')
  end
end