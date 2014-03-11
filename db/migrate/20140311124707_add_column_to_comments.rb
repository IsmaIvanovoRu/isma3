class AddColumnToComments < ActiveRecord::Migration
  def change
    add_column :comments, :published, :boolean, :null => false, :default => false
  end
end
