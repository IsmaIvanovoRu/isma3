class CreateAchievementResults < ActiveRecord::Migration
  def change
    create_table :achievement_results do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
