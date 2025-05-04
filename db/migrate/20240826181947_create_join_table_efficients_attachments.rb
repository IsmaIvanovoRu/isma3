class CreateJoinTableEfficientsAttachments < ActiveRecord::Migration
  def change
    create_join_table :efficients, :attachments do |t|
      # t.index [:efficient_id, :attachment_id]
      # t.index [:attachment_id, :efficient_id]
    end
  end
end
