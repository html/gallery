class Category < ActiveRecord::Base
  cattr_accessor :options
  attr_accessible :title
  validates_presence_of :title
  has_many :albums
  @@options = {
    1 => 'Portfolio/Weddings',
    2 => 'Portfolio/Portraits',
    3 => 'Portfoli/Travel'
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
