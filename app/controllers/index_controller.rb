class IndexController < ApplicationController
  skip_before_filter :has_permission?
  layout 'front'
  before_filter :assign_menu

  def index
  end

  def images
    @album = Album.find_by_id params[:album_id]
    not_found_unless @album

    @items = Photo.paginate_by_album_id(params[:album_id], :page => params[:page], :per_page => 9)
  end

  def cat
    @category = Category.find_by_id params[:id]
    not_found_unless @category

    @items = Album.paginate_by_category_id @category, :page => params[:page]
  end

  protected
  def assign_menu
    @menu = Category.get_menu_items
  end
end
