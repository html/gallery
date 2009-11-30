class Category < ActiveRecord::Base
  attr_accessible :title
  validates_presence_of :title
  has_many :albums

  def get_title
    title.nil? || title.size.zero? ? '< no title >' : title
  end

end
