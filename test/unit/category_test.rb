require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  should_validate_presence_of :title
  should_have_many :albums
  should_validate_presence_of :menu_id
end
