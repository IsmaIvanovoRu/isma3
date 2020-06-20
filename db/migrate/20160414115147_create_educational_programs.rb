class CreateEducationalPrograms < ActiveRecord::Migration
  def change
    create_table :educational_programs do |t|
      t.string :name
      t.string :code
      t.string :form
      t.string :duration
      t.references :educational_standart, index: true, foreign_key: true
      t.string :level
      t.references :accreditation, index: true, foreign_key: true
      t.references :attachment, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
