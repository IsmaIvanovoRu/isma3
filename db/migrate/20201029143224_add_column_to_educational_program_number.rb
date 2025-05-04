class AddColumnToEducationalProgramNumber < ActiveRecord::Migration
  def change
    add_column :educational_program_numbers, :number_foreign, :integer, default: 0
  end
end
