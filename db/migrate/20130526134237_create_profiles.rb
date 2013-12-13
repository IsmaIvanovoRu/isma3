class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.references :user, index: true
      t.string :first_name, :null => false, :default => ""
      t.string :middle_name, :default => ""
      t.string :last_name, :null => false, :default => ""
      t.references :degree, index: true
      t.references :academic_title, index: true
      t.string :phone, :default => ""
      t.text :about

      t.timestamps
    end
  end
end
