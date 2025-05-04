class ChangeColumnNameInSubject < ActiveRecord::Migration
  def change
    rename_column :subjects, :attachment_id, :annotation_attachment_id
  end
end
