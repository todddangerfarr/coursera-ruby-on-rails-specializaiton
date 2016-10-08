class TodoItem < ActiveRecord::Base
  def self.get_completed_count
    TodoItem.where(completed: true).count 
  end
end
