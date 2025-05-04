class CreateCriteria < ActiveRecord::Migration
  def change
    create_table :criteria do |t|
      t.string :chapter
      t.text :point
      t.integer :min
      t.integer :max
      t.text :comment
      t.string :criterium_type
      t.boolean :actual, default: false

      t.timestamps null: false
    end
  end
end
