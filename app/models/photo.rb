class Photo < ActiveRecord::Base
  attr_accessible :title, :photo
  has_attached_file :photo, :storage => :filesystem, :styles => { :thumb => ["100x100", :png]}, :whiny_thumbnails => true, :whiny => true
  validates_presence_of :title
  validates_attachment_presence :photo
end
