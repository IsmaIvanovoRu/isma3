class AddScoreToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :score, :integer
  end
end
