require 'test_helper'

class PhotosControllerTest < ActionController::TestCase
  setup do
    PhotosController.model = Photo
    PhotosController.parent_model = Album
    PhotosController.parent_key = :album_id
  end

  context "index action" do
    should "render index template" do
      get :index
      assert_template 'index'
    end

    context "with specified album" do
      should "render only items that belong to album" do
        parent = Factory(:album)
        album = Factory(:photo, :album_id => parent)

        get :index, :album_id => parent

        assigns(:photos).each do |item|
          assert_not_nil item.album_id
          assert_equal parent.id, item.album_id
        end
      end
    end
  end
  
  context "show action" do
    should "render show template" do
      get :show, :id => Photo.first
      assert_template 'show'
    end
  end
  
  context "new action" do
    should "render new template" do
      get :new, :album_id => Album.first
      assert_template 'new'
    end

    should "fail when album is not specified" do
      get :new
      assert_response :not_found
    end
  end
  
  context "create action" do
    should "render new template when model is invalid" do
      parent = Factory(:album)
      photo = Factory.build(:photo, :album_id => parent).attributes
      Photo.any_instance.stubs(:valid?).returns(false)
      post :create, :album_id => parent, :photo => photo
      assert_template 'new'
    end
    
    should "redirect when model is valid" do
      parent = Factory(:album)
      photo = Factory.build(:photo, :album_id => parent).attributes
      Photo.any_instance.stubs(:valid?).returns(true)
      post :create, :album_id => parent, :photo => photo
      assert_redirected_to photo_url(assigns(:photo))
    end

    should "assign parent id on creating" do
      parent = Factory(:album)
      album = Factory.build(:photo, :album_id => parent).attributes
      post :create, :album_id => parent, :photo => album
      assert_equal parent.id, assigns(:photo).album_id
    end

    should "fail when album_id is not specified" do
      post :create
      assert_response :not_found
    end
  end
  
  context "edit action" do
    should "render edit template" do
      get :edit, :id => Photo.first
      assert_template 'edit'
    end
  end
  
  context "update action" do
    should "render edit template when model is invalid" do
      Photo.any_instance.stubs(:valid?).returns(false)
      put :update, :id => Photo.first
      assert_template 'edit'
    end
  
    should "redirect when model is valid" do
      Photo.any_instance.stubs(:valid?).returns(true)
      put :update, :id => Photo.first
      assert_redirected_to photo_url(assigns(:photo))
    end
  end
  
  context "destroy action" do
    should "destroy model and redirect to index action" do
      photo = Photo.first
      delete :destroy, :id => photo
      assert_redirected_to photos_url
      assert !Photo.exists?(photo.id)
    end
  end
end
