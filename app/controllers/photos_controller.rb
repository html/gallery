class PhotosController < ApplicationController
  @@parent_model = Album
  @@parent_key = :album_id
  @@model = Photo
  before_filter :require_parent_item, :only => [:new, :create, :update, :edit]
  before_filter :optional_require_parent_item, :only => [:index, :show]

  def index
    if params[:album_id]
      @photos = parent_item.photos
    else
      @photos = Photo.all
    end
  end
  
  def show
    if params[:album_id]
      @photo = Photo.find_by_id_and_album_id(params[:id], parent_item)
      not_found_unless @photo
    else
      @photo = Photo.find(params[:id])
    end
  end
  
  def new
    @photo = Photo.new
  end
  
  def create
    @photo = Photo.new(params[:photo])
    @photo.album_id = parent_item.to_param
    if @photo.save
      flash[:notice] = "Successfully created photo."
      redirect_to @photo
    else
      render :action => 'new'
    end
  end
  
  def edit
    @photo = Photo.find(params[:id])
  end
  
  def update
    @photo = Photo.find(params[:id])
    if @photo.update_attributes(params[:photo])
      flash[:notice] = "Successfully updated photo."
      redirect_to @photo
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @photo = Photo.find(params[:id])
    @photo.destroy
    flash[:notice] = "Successfully destroyed photo."
    redirect_to photos_url
  end
end
