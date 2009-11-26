require 'test_helper'

class AlbumTest < ActiveSupport::TestCase
  should "be valid" do
    assert Album.new.valid?
  end
end
