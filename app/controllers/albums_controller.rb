class AlbumsController < ApplicationController
  @@parent_key = :category_id
  @@parent_model = Category
  @@model = Album
  before_filter :require_parent_item, :only => [:new, :create]
  #before_filter :optional_require_parent_item, :only => :index

  def index
    if params[:category_id]
      @albums = parent_item.albums
    else
      @albums = Album.all
    end
  end
  
  def show
    @album = Album.find(params[:id])
  end
  
  def new
    @album = Album.new
  end
  
  def create
    @album = Album.new(params[:album])
    @album.category_id = parent_item.to_param
    if @album.save
      flash[:notice] = "Successfully created album."
      redirect_to @album
    else
      render :action => 'new'
    end
  end
  
  def edit
    @album = Album.find(params[:id])
  end
  
  def update
    @album = Album.find(params[:id])
    if @album.update_attributes(params[:album])
      flash[:notice] = "Successfully updated album."
      redirect_to @album
    else
      render :action => 'edit'
    end
  end
  
  def destroy
    @album = Album.find(params[:id])
    @album.destroy
    flash[:notice] = "Successfully destroyed album."
    redirect_to albums_url
  end
end
