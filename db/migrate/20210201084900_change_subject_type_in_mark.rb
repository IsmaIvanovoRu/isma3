class ChangeSubjectTypeInMark < ActiveRecord::Migration
  def change
    change_column :marks, :subject, :text, default: nil
  end
end
