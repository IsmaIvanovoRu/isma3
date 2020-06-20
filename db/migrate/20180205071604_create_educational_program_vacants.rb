class CreateEducationalProgramVacants < ActiveRecord::Migration
  def change
    create_table :educational_program_vacants do |t|
      t.references :educational_program, index: true, foreign_key: true
      t.integer :stage, default: 0
      t.integer :number_federal, default: 0
      t.integer :number_regional, default: 0
      t.integer :number_local, default: 0
      t.integer :number_personal, default: 0
      t.date :date

      t.timestamps null: false
    end
  end
end
