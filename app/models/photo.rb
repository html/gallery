class Photo < ActiveRecord::Base
  attr_accessible :photo
  has_attached_file :photo, :storage => :filesystem, :styles => {
    :original => ["1024x768", :png],
    :preview => ["550x315", :png],
    :thumb => ["100x100#", :png]
  }, :whiny_thumbnails => true, :whiny => true
  validates_attachment_presence :photo
  belongs_to :album
  validates_associated :album
  validates_attachment_presence :photo
end
