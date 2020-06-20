class CreateMenus < ActiveRecord::Migration
  def change
    create_table :menus do |t|
      t.string :location, :null => false, :default => ""
      t.string :title, :null => false, :default => ""
      t.string :path, :null => false, :default => ""
      t.integer :weigth, :null => false, :default => 0
      t.boolean :private,  :null => false, :default => false

      t.timestamps
    end
    add_index :menus, :title
    add_index :menus, :path
  end
end
