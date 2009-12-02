class Album < ActiveRecord::Base
  attr_accessible :title, :image
  validates_presence_of :title
  has_many :photos
  has_attached_file :image, :storage => :filesystem, :styles => { :thumb => ["100x100", :png]}, :whiny_thumbnails => true, :whiny => true
end
