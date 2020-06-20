class AddScoreToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :score, :integer, default: 0
  end
end
