class RemoveTitleFromPhotos < ActiveRecord::Migration
  def self.up
    remove_column :photos, :title
  end

  def self.down
    add_column :photos, :title, :string
  end
end
