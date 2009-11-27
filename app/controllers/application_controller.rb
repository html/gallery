# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  @@model = nil
  @@parent_model = nil
  @@parent_key = nil
  @parent_item = nil
  around_filter :catch_exceptions
  #before_filter :login_required
  #before_filter :has_permission?
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  # filter_parameter_logging :password
  def catch_exceptions
    begin
      yield
    rescue => exception
      if exception.class == ActiveRecord::RecordNotFound
        render :file => "#{RAILS_ROOT}/public/404.html", :status => 404 and return
      else
        raise
      end
    end
  end

  def parent_item
    @parent_item ||= @@parent_model.find_by_id(params[@@parent_key])
  end

  def require_parent_item
    unless parent_item
      raise ActiveRecord::RecordNotFound
    end
  end

  def optional_require_parent_item
    if params[@@parent_key]
      require_parent_item
    end
  end

  class << self
    def model
      @@model
    end

    def parent_model
      @@parent_model
    end

    def parent_key
      @@parent_key
    end

    def model=(value)
      @@model=value
    end

    def parent_model=(value)
      @@parent_model=value
    end

    def parent_key=(value)
      @@parent_key=value
    end
  end
end
