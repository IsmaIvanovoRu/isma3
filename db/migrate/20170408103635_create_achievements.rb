class CreateAchievements < ActiveRecord::Migration
  def change
    create_table :achievements do |t|
      t.references :user, index: true, foreign_key: true
      t.string :event_name
      t.references :achievement_category, index: true, foreign_key: true
      t.references :achievement_result, index: true, foreign_key: true
      t.date :event_date
      t.text :comment
      t.boolean :published, default: false

      t.timestamps null: false
    end
  end
end
