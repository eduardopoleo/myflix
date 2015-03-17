class AddLargeCoverToVideos < ActiveRecord::Migration
  def up
    add_column :videos, :large_cover, :string
    add_column :videos, :small_cover, :string
    remove_column :videos, :small_cover_url
    remove_column :videos, :large_cover_url
  end

  def down
    remove_column :videos, :large_cover
    remove_column :videos, :small_cover
    add_column :videos, :small_cover_url, :string  
    add_column :videos, :large_cover_url, :string
  end
end
