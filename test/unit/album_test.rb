require 'test_helper'

class AlbumTest < ActiveSupport::TestCase
  should_validate_presence_of :title
end
