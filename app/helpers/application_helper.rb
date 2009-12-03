# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper

  def link_to_item_with_count(caption, item, count)
    if count > 0
      link_to(t(caption) + (count ? " (#{count})" : ''), item)
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

  #Copypasted localized version of link_to
  def link_to(*args, &block)
    if block_given?
      options      = args.first || {}
      html_options = args.second
      concat(link_to(capture(&block), options, html_options))
    else
      name         = t(args.first, {:force => true})
      options      = args.second || {}
      html_options = args.third

      url = url_for(options)

      if html_options
        html_options = html_options.stringify_keys
        href = html_options['href']
        convert_options_to_javascript!(html_options, url)
        tag_options = tag_options(html_options)
      else
        tag_options = nil
      end

      href_attr = "href=\"#{url}\"" unless href
      "<a #{href_attr}#{tag_options}>#{name || url}</a>"
    end
  end

  def t(key, options = {})
    I18n.t(key, options)
  end

  def default_pagination(*attrs)
    render :partial => '/paginate_part', *attrs
  end
end
