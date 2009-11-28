# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def link_to_item_with_count(caption, item, count)
    if count > 0
      link_to(caption + (count ? " (#{count})" : ''), item)
    end
  end
end
