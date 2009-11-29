class Category < ActiveRecord::Base
  attr_accessible :title
  validates_presence_of :title
  has_many :albums
  validate :no_more_than_6_rows, :on => :create

  def get_title
    title.nil? || title.size.zero? ? '< no title >' : title
  end

  def self.list_all
    items = all
    return items if items.size == 6

    if items.size < 6
      items.size.upto(5) do
        item = new
        item.save(false)
        items.push(item)
      end
    end

    items
  end

  def no_more_than_6_rows
    errors.add(:title, "Can't be no more than 6 rows in a table") if self.class.count >= 6
  end

  def per_page
    6
  end
end
