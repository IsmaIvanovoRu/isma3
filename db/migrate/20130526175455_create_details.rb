class CreateDetails < ActiveRecord::Migration
  def change
    create_table :details do |t|
      t.string :key, :null => false, :default => ""
      t.string :value, :null => false, :default => ""

      t.timestamps
    end
  end
end
