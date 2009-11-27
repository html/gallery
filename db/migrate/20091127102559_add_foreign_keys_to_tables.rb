class AddForeignKeysToTables < ActiveRecord::Migration
  def self.up
    add_column :albums, :category_id, :integer
    add_column :photos, :album_id, :integer
  end

  def self.down
    remove_column :albums, :category_id
    remove_column :photos, :album_id
  end
end
