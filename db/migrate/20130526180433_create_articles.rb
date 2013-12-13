class CreateArticles < ActiveRecord::Migration
  def change
    create_table :articles do |t|
      t.references :user, index: true
      t.string :title, :null => false, :default => ""
      t.text :content, :null => false, :default => ""
      t.date :exp_date
      t.boolean :published, :default => false
      t.boolean :fixed, :default => false
      t.boolean :commentable, :default => false
      t.references :division, index: true
      t.references :group, index: true
      t.references :article_type, index: true

      t.timestamps
    end
  end
end
