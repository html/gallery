# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def link_to_item_with_count(caption, item, count)
    if count > 0
      link_to(caption + (count ? " (#{count})" : ''), item)
    end
  end

  def albums_user_path(item)
    return :controller => :index, :action => :albums, :id => item
  end

  def cat_user_path(item)
    return :controller => :index, :action => :cat, :id => item
  end

  def photos_user_path(item)
    return :controller => :index, :action => :images, :album_id => item
  end
end
