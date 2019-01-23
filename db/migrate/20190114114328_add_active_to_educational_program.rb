class AddActiveToEducationalProgram < ActiveRecord::Migration
  def change
    add_column :educational_programs, :active, :boolean, default: true
  end
end
