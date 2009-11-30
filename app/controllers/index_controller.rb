class IndexController < ApplicationController
  layout 'front'

  def index
  end

  def images
    @items = Photo.find_all_by_album_id(params[:album_id])
  end

  def cat
    @category = Category.find_by_id params[:id]
    not_found_unless @category

    @items = Album.paginate_by_category_id @category, :page => params[:page]
  end

  def album
    @album = Album.find_by_id params[:id]

    not_found_unless @album

    @items = Photo.paginate_by_id params[:id]
  end
end
