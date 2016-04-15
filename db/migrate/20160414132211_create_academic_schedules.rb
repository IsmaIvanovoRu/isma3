class CreateAcademicSchedules < ActiveRecord::Migration
  def change
    create_table :academic_schedules do |t|
      t.string :name
      t.references :attachment, index: true, foreign_key: true
      t.references :educational_program, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
