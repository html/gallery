# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper
  def title(page_title, *args)
    @content_for_title = t(page_title.to_s)
    options = args.extract_options!

    if options[:parent]
      (@content_for_title += " " + sprintf(t("for #{options[:parent][:name]} %s"), h(options[:parent][:title] || options[:parent][:item].title))) if options[:parent][:item] 
    end
    @show_title = true
  end
  
  def show_title?
    @show_title
  end
  
  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end
  
  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end
end
