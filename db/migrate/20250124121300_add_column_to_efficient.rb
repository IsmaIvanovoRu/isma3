class AddColumnToEfficient < ActiveRecord::Migration
  def change
    add_column :efficients, :archived, :boolean, default: false
  end
end
