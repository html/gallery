ENV["RAILS_ENV"] = "test"
require File.expand_path(File.dirname(__FILE__) + "/../config/environment")
require 'test_help'
require 'mocha'
require 'shoulda'
require 'factory_girl'


Factory.define :category do |f|
  f.title 'Test title'
  f.menu_id 1
end

parent_category = Factory(:category)

Factory.define :album do |f|
  f.title 'Test title'
  f.category_id parent_category.id
  f.image { File.new(File.join(File.dirname(__FILE__), 'fixtures', '1.gif'), 'rb') }
end

parent_album = Factory(:album)

Factory.define :photo do |f|
  f.photo { File.new(File.join(File.dirname(__FILE__), 'fixtures', '1.gif'), 'rb') }
  f.album_id parent_album.id
end

class ActiveSupport::TestCase
  include AuthenticatedTestHelper
  # Transactional fixtures accelerate your tests by wrapping each test method
  # in a transaction that's rolled back on completion.  This ensures that the
  # test database remains unchanged so your fixtures don't have to be reloaded
  # between every test method.  Fewer database queries means faster tests.
  #
  # Read Mike Clark's excellent walkthrough at
  #   http://clarkware.com/cgi/blosxom/2005/10/24#Rails10FastTesting
  #
  # Every Active Record database supports transactions except MyISAM tables
  # in MySQL.  Turn off transactional fixtures in this case; however, if you
  # don't care one way or the other, switching from MyISAM to InnoDB tables
  # is recommended.
  #
  # The only drawback to using transactional fixtures is when you actually 
  # need to test transactions.  Since your test is bracketed by a transaction,
  # any transactions started in your code will be automatically rolled back.
  self.use_transactional_fixtures = true

  # Instantiated fixtures are slow, but give you @david where otherwise you
  # would need people(:david).  If you don't want to migrate your existing
  # test cases which use the @david style and don't mind the speed hit (each
  # instantiated fixtures translates to a database query per test method),
  # then set this back to true.
  self.use_instantiated_fixtures  = false

  # Setup all fixtures in test/fixtures/*.(yml|csv) for all tests in alphabetical order.
  #
  # Note: You'll currently still have to declare fixtures explicitly in integration tests
  # -- they do not yet inherit this setting
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def child_and_parent_fixtures(parent_model, child_model, key)
    parent = Factory(parent_model)
    [Factory(child_model, key => parent), parent]
  end

  def check_links_work_correctly
    assert_select 'a' do |links|
      links.each do |link|
        debugger
        get link[0].attributes["href"]
        assert_response :success
        link
      end
    end
  end
end
