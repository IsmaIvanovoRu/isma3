class AddEmployeeListToEducationalProgram < ActiveRecord::Migration
  def change
    add_column :educational_programs, :employee_list_id, :integer
  end
end
