class CreateEfficients < ActiveRecord::Migration
  def change
    create_table :efficients do |t|
      t.references :criterium, index: true, foreign_key: true
      t.references :user, index: true, foreign_key: true
      t.string :link
      t.float :value
      t.boolean :checked, default: false

      t.timestamps null: false
    end
  end
end
