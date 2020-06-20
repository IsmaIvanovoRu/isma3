class CreateJoinTableDivisionAttachment < ActiveRecord::Migration
  def change
    create_join_table :divisions, :attachments do |t|
      # t.index [:division_id, :attachment_id]
      # t.index [:attachment_id, :division_id]
    end
  end
end
