class AddColumnToClassroom < ActiveRecord::Migration
  def change
    add_column :classrooms, :ovz, :text
  end
end
