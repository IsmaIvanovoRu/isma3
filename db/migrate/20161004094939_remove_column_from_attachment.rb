class RemoveColumnFromAttachment < ActiveRecord::Migration
  def change
    remove_column :attachments, :data, :string
    remove_column :attachments, :thumbnail, :string
  end
end
