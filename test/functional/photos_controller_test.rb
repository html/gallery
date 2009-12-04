require 'test_helper'

class PhotosControllerTest < ActionController::TestCase
  setup do
    PhotosController.model = Photo
    PhotosController.parent_model = Album
    PhotosController.parent_key = :album_id
  end

  context "index action" do
    should "render index template" do
      parent = Factory(:album)
      Photo.update_all ["album_id = ?", parent.id]
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
          assert_equal parent.id, item.album_id
        end
      end
    end
  end
  
  context "show action" do
    should "render show template" do
      get :show, :id => Factory(:photo)
      assert_template 'show'
    end

    should "failure when item and parent are not related" do
      p = Factory(:album)
      item = Factory(:photo, :album_id => p.id - 1)
      get :show, :id => item, :album_id => p
      assert_response :not_found
    end
  end
  
  context "new action" do
    should "render new template" do
      get :new, :album_id => Factory(:album)
      assert_template 'new'
    end

    should "have 1 form with correct action" do
      c = Factory(:album)
      get :new, :album_id => c

      assert_template 'new'
      assert_select "form", 1 do |f|
        assert_equal album_photos_path(c.to_param, nil), f[0].attributes["action"]
      end
    end

    should "fail when album is not specified" do
      get :new
      assert_response :not_found
    end

    should "fail when album does not exists" do
      get :new, :album_id => -1
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
      c,p = get_child_parent_fixtures
      get :edit, :id => c, :album_id => p
      assert_template 'edit'
    end

    should "fail when album is not specified" do
      post :edit, :id => Photo.first
      assert_response :not_found
    end
  end
  
  context "update action" do
    should "redirect when model is valid" do
      Photo.any_instance.stubs(:valid?).returns(true)
      child, parent = get_child_parent_fixtures
      put :update, :id => child, :album_id => parent
      assert_redirected_to photo_url(assigns(:photo))
    end

    should "fail when album is not specified" do
      post :update, :id => Photo.first, :album_id => nil, :album => Factory.build(:album).attributes
      assert_response :not_found
    end
  end
  
  context "destroy action" do
    should "destroy model and redirect to index action" do
      photo = Factory(:photo)
      delete :destroy, :id => photo
      assert_redirected_to photos_url
      assert !Photo.exists?(photo.id)
    end
  end

  def get_child_parent_fixtures
    child_and_parent_fixtures(:album, :photo, :album_id)
  end
end
