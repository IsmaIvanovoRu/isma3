class AddNewColumnsToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :teaching_level, :string
    add_column :profiles, :employee_qualification, :string
  end
end
