
class Session < ActiveRecord::Base
  def self.is_creatable_by(user, parent = nil)
    true
  end

  def is_deletable_by(user, parent = nil)
    debugger
    true
  end

  def self.is_deletable_by(user, parent = nil)
    debugger
    true
  end
end
