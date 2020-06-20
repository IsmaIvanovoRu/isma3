class AddColumnToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :skip_frontend, :boolean, :default => false
  end
end
