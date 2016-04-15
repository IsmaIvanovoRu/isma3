class CreateMethodologicalSupports < ActiveRecord::Migration
  def change
    create_table :methodological_supports do |t|
      t.references :attachment, index: true, foreign_key: true
      t.references :educational_program, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
