class AlbumsController < ApplicationController
  @@parent_key = :category_id
  @@parent_model = Category
  @@model = Album
  before_filter :require_parent_item, :only => [:new, :create, :update, :edit, :list]
  before_filter :optional_require_parent_item, :only => [:index, :show]

  def index
    if params[:category_id]
      @albums = Album.paginate_by_category_id parent_item, :page => params[:page]
    else
      @albums = Album.paginate :page => params[:page]
    end
  end

  def show
    if params[:category_id]
      @album = Album.find_by_id_and_category_id(params[:id], parent_item)
      not_found_unless @album
    else
      @album = Album.find_by_id(params[:id])
    end
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
    edit

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

  def change_image
    @album = Album.find(params[:id])
    @images = Photo.find_all_by_album_id @album
    @first_image = @images.first

    if request.post? && @album.add_image(params[:photo])
      flash[:notice] = "Successfully changed image."
      redirect_to albums_url
    end
  end
end
