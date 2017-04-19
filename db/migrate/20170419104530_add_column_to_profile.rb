class AddColumnToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :published, :boolean, default: true
  end
end
