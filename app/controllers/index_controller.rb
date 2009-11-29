class IndexController < ApplicationController
  layout 'front'

  def index
  end

  def images
    @items = Photo.find_all_by_album_id(params[:album_id])
  end
end
