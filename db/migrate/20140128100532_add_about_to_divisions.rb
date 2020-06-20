class AddAboutToDivisions < ActiveRecord::Migration
  def change
    add_column :divisions, :about, :text
  end
end
