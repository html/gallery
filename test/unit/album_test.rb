require 'test_helper'

class AlbumTest < ActiveSupport::TestCase
  should_validate_presence_of :title
  should_have_many :photos
  should_have_attached_file :image
end
