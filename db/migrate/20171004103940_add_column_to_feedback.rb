class AddColumnToFeedback < ActiveRecord::Migration
  def change
    add_column :feedbacks, :private, :boolean, default: false
  end
end
