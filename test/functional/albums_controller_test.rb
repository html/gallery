require 'test_helper'

class AlbumsControllerTest < ActionController::TestCase
  setup do
    AlbumsController.model = Album
    AlbumsController.parent_model = Category
    AlbumsController.parent_key = :category_id
  end

  context "index action" do
    should "render index template" do
      Album.update_all ['category_id = ?', Factory(:category).id]
      get :index
      assert_template 'index'
    end

    context "with specified category" do
      should "render only items that belong to category" do
        parent = Factory(:category)
        album = Factory(:album, :category_id => parent)

        get :index, :category_id => parent

        assert_not_nil assigns(:albums)
        assigns(:albums).each do |item|
          assert_not_nil item.category_id
          assert_equal parent.id, item.category_id
        end
      end
    end
  end
  
  context "show action" do
    should "render show template" do
      get :show, :id => Album.first
      assert_template 'show'
    end

    should "failure when item and parent are not related" do
      p = Factory(:category)
      item = Factory(:album, :category_id => p.id - 1)
      get :show, :id => item, :category_id => p
      assert_response :not_found
    end
  end
  
  context "new action" do
    should "render new template" do
      get :new, :category_id => Factory(:category)
      assert_template 'new'
    end

    should "have 1 form with correct action" do
      c = Factory(:category)
      get :new, :category_id => c

      assert_template 'new'
      assert_select "form", 1 do |f|
        assert_equal category_albums_path(c.to_param, nil), f[0].attributes["action"]
      end
    end

    should "fail when category is not specified" do
      get :new
      assert_response :not_found
    end

    should "fail when category does not exists" do
      get :new, :category_id => -1
      assert_response :not_found
    end
  end
  
  context "create action" do
    should "render new template when model is invalid" do
      parent = Factory(:category)
      album = Factory.build(:album, :category_id => parent).attributes
      Album.any_instance.stubs(:valid?).returns(false)
      post :create, :category_id => parent, :album => album
      assert_template 'new'
    end
    
    should "redirect when model is valid" do
      parent = Factory(:category)
      album = Factory.build(:album, :category_id => parent).attributes
      Album.any_instance.stubs(:valid?).returns(true)
      post :create, :category_id => parent, :album => album
      assert_redirected_to album_url(assigns(:album))
    end

    should "assign parent id on creating" do
      parent = Factory(:category)
      album = Factory.build(:album, :category_id => parent).attributes
      post :create, :category_id => parent, :album => album
      assert_equal parent.id, assigns(:album).category_id
    end

    should "fail when category is not specified" do
      post :create
      assert_response :not_found
    end
  end
  
  context "edit action" do
    should "render edit template" do
      c,p = get_child_parent_fixtures
      c.category = p;c.save
      get :edit, :id => c, :category_id => p
      assert_template 'edit'
    end

    should "fail when category is not specified" do
      post :edit, :id => Album.first
      assert_response :not_found
    end
  end
  
  context "update action" do
    should "render edit template when model is invalid" do
      child, parent = get_child_parent_fixtures
      child.category = parent
      child.save
      put :update, :id => child, :category_id => parent, :album => {:title => ''}
      assert_template 'edit'
    end
  
    should "redirect when model is valid" do
      Album.any_instance.stubs(:valid?).returns(true)
      child, parent = get_child_parent_fixtures
      put :update, :id => child, :category_id => parent
      assert_redirected_to album_url(assigns(:album))
    end

    should "fail when category is not specified" do
      post :update, :id => Album.first, :category_id => nil, :album => Factory.build(:album).attributes
      assert_response :not_found
    end
  end
  
  context "destroy action" do
    should "destroy model and redirect to index action" do
      album = Album.first
      delete :destroy, :id => album
      assert_redirected_to albums_url
      assert !Album.exists?(album.id)
    end
  end

  def get_child_parent_fixtures
    child_and_parent_fixtures(:category, :album, :category_id)
  end
end
