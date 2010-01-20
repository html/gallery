class Category < ActiveRecord::Base
  cattr_accessor :titles
  attr_accessible :title, :menu_id
  validates_presence_of :title
  validates_presence_of :menu_id
  validates_numericality_of :menu_id, :less_than_or_equal => 3, :more_than_or_equal => 1
  has_many :albums

  @@options = {
    1 => 'portfolio',
    2 => 'vacancy',
    3 => 'faq',
    4 => 'na'
  }

  @@titles = {
    1 => 'Weddings',
    2 => 'Portraits',
    3 => 'Travels',
    4 => 'Nightlife'
  }

  def get_title
    title.nil? || title.size.zero? ? '< no title >' : title
  end

  def self.get_menu_items
    @@options.map do |key,val|
      {:title => val, :children => find_all_by_menu_id(key)}
    end
  end

end
