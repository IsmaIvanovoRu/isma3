class CreateDivisions < ActiveRecord::Migration
  def change
    create_table :divisions do |t|
      t.string :name, :null => false, :default => ""
      t.references :division_type, index: true
      t.string :address, :default => ""
      t.float :latitude, :default => 0
      t.float :longitude, :default => 0

      t.timestamps
    end
  end
end
