class AddYearStartToEducationalProgram < ActiveRecord::Migration
  def change
    add_column :educational_programs, :year_start, :integer
  end
end
