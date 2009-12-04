require 'test_helper'

class PhotoTest < ActiveSupport::TestCase
  should_have_attached_file :photo
  should_validate_attachment_presence :photo
  should_belong_to :album
end
