# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def link_to_item_with_count(caption, item, count)
    if count > 0
      link_to(caption + (count ? " (#{count})" : ''), item)
    end
  end

  def albums_user_path(item)
    return url_for(:controller => :index, :action => :albums, :id => item)
  end

  def cat_user_path(item)
    return url_for(:controller => :index, :action => :cat, :id => item)
  end

  def photos_user_path(item)
    return url_for(:controller => :index, :action => :images, :album_id => item)
  end

  class Once
    @@actions = {}
    def self.do(name, &block)
      if !@@actions[name]
        @@actions[name] = true
        return yield
      end
    end
  end

  def javascript_include_jquery 
    Once::do(:load_jquery) {
      javascript_include_tag 'jquery.min'
    }
  end
end
