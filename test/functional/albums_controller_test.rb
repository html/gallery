require 'test_helper'

class AlbumsControllerTest < ActionController::TestCase
  setup do
    AlbumsController.model = Album
    AlbumsController.parent_model = Category
    AlbumsController.parent_key = :category_id
  end

  context "index action" do
    should "render index template" do
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
  end
  
  context "new action" do
    should "render new template" do
      get :new, :category_id => Factory(:category)
      assert_template 'new'
    end

    should "fail when category is not specified" do
      get :new
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
      get :edit, :id => Album.first
      assert_template 'edit'
    end
  end
  
  context "update action" do
    should "render edit template when model is invalid" do
      Album.any_instance.stubs(:valid?).returns(false)
      put :update, :id => Album.first
      assert_template 'edit'
    end
  
    should "redirect when model is valid" do
      Album.any_instance.stubs(:valid?).returns(true)
      put :update, :id => Album.first
      assert_redirected_to album_url(assigns(:album))
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
end
