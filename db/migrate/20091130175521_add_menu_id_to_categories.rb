class AddMenuIdToCategories < ActiveRecord::Migration
  def self.up
    add_column :categories, :menu_id, :string
    Category.update_all ['menu_id = ?', Category.options.first[0]]
  end

  def self.down
    remove_column :categories, :menu_id
  end
end
