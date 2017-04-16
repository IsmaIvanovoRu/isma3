class CreateJoinTableAchievementAttachment < ActiveRecord::Migration
  def change
    create_join_table :achievements, :attachments do |t|
      # t.index [:achievement_id, :attachment_id]
      # t.index [:attachment_id, :achievement_id]
    end
  end
end
