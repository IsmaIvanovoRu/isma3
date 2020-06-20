class ChangeColumnTypeInDetails < ActiveRecord::Migration
  def change
    change_column :details, :value, :text, default: nil
  end
end
