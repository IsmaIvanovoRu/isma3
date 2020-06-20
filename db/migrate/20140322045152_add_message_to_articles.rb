class AddMessageToArticles < ActiveRecord::Migration
  def change
    add_column :articles, :message, :string, :default => ''
  end
end
