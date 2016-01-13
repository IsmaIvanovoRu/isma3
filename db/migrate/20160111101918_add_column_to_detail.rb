class AddColumnToDetail < ActiveRecord::Migration
  def change
    add_column :details, :tag_type, :string
    add_column :details, :block, :boolean
    add_column :details, :tag_name, :string
  end
end
