class CreateClassrooms < ActiveRecord::Migration
  def change
    create_table :classrooms do |t|
      t.references :subject, index: true, foreign_key: true
      t.text :description
      t.text :location
      t.text :equipment

      t.timestamps null: false
    end
  end
end
