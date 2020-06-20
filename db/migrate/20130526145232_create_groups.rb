class CreateGroups < ActiveRecord::Migration
  def change
    create_table :groups do |t|
      t.references :parent, index: true
      t.string :name, :null => false, :default => ""
      t.boolean :administrator, :null => false, :default => false
      t.boolean :moderator, :null => false, :default => false
      t.boolean :writer, :null => false, :default => false
      t.boolean :reader, :null => false, :default => false
      t.boolean :commentator, :null => false, :default => false

      t.timestamps
    end
  end
end
