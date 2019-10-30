class AddColumnToEducationalProgram < ActiveRecord::Migration
  def change
    add_column :educational_programs, :language, :string
  end
end
