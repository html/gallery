ActiveRecord::Base.class_eval do |c|
  def c.per_page
    10
  end
end
