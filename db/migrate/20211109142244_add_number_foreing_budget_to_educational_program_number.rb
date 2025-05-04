class AddNumberForeingBudgetToEducationalProgramNumber < ActiveRecord::Migration
  def change
    add_column :educational_program_numbers, :number_foreign_budget, :integer, default: 0
  end
end
