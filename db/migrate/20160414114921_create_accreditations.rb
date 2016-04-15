class CreateAccreditations < ActiveRecord::Migration
  def change
    create_table :accreditations do |t|
      t.string :number
      t.date :date_of_issue
      t.date :expiration_date
      t.references :attachment, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
