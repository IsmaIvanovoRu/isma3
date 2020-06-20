class CreateDegrees < ActiveRecord::Migration
  def change
    create_table :degrees do |t|
      t.string :name, :null => false, :default => ""
      t.string :short_name, :null => false, :default => ""

      t.timestamps
    end
  end
end
