class CreatePractices < ActiveRecord::Migration
  def change
    create_table :practices do |t|
      t.string :name
      t.references :attachment, index: true, foreign_key: true
      t.references :educational_program, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
