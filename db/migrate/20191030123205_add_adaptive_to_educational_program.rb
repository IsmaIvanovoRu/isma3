class AddAdaptiveToEducationalProgram < ActiveRecord::Migration
  def change
    add_column :educational_programs, :adaptive, :boolean, default: false
  end
end
