ActiveRecord::Base.class_eval do |c|
  def is_readable_by(user, parent = nil)
    user.is_admin
  end

  def is_deletable_by(user, parent = nil)
    user.is_admin
  end

  def c.is_indexable_by(user, parent = nil)
    user
  end

  def c.is_creatable_by(user, parent = nil)
    user.is_admin
  end

  def is_updatable_by(user, parent = nil)
    user.is_admin
  end
end
