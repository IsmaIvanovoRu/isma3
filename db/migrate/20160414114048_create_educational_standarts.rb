class CreateEducationalStandarts < ActiveRecord::Migration
  def change
    create_table :educational_standarts do |t|
      t.string :name
      t.string :level
      t.string :url

      t.timestamps null: false
    end
  end
end
