class CreateJoinTableArticleAttachment < ActiveRecord::Migration
  def change
    create_join_table :articles, :attachments do |t|
      # t.index [:article_id, :attachment_id]
      # t.index [:attachment_id, :article_id]
    end
  end
end
