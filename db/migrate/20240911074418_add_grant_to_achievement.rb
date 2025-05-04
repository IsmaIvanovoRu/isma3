class AddGrantToAchievement < ActiveRecord::Migration
  def change
    add_column :achievements, :grant, :boolean, default: false
  end
end
