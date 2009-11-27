require 'test_helper'

class CategoryTest < ActiveSupport::TestCase
  should_validate_presence_of :title
end
