class Photo < ActiveRecord::Base
  attr_accessible :photo
  has_attached_file :photo, :storage => :filesystem, :styles => { :thumb => ["100x100", :png]}, :whiny_thumbnails => true, :whiny => true
  validates_attachment_presence :photo
end
