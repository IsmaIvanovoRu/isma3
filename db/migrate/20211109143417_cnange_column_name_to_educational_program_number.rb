class CnangeColumnNameToEducationalProgramNumber < ActiveRecord::Migration
  def change
    change_table :educational_program_numbers do |t|
      t.rename :number_foreign, :number_foreign_paid
    end
  end
end
