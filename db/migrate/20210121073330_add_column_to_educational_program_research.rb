class AddColumnToEducationalProgramResearch < ActiveRecord::Migration
  def change
    add_column :educational_program_researches, :result_nir, :text
  end
end
