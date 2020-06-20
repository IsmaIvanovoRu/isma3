class CreateMarks < ActiveRecord::Migration
  def change
    create_table :marks do |t|
      t.references :user, index: true, foreign_key: true
      t.references :educational_program, index: true, foreign_key: true
      t.string :subject, default: ''
      t.integer :value, default: 0

      t.timestamps null: false
    end
  end
end
