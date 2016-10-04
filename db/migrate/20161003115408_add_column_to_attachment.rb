class AddColumnToAttachment < ActiveRecord::Migration
  def change
    add_column :attachments, :file_name, :string
    add_column :attachments, :thumbnail_name, :string
  end
end
