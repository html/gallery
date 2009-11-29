ActiveRecord::Base.class_eval do |c|
  def c.per_page
    5
  end
end
