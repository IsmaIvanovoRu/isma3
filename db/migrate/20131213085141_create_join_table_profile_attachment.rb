class CreateJoinTableProfileAttachment < ActiveRecord::Migration
  def change
    create_join_table :profiles, :attachments do |t|
      # t.index [:profile_id, :attachment_id]
      # t.index [:attachment_id, :profile_id]
    end
  end
end
