class CreateArticleTypes < ActiveRecord::Migration
  def change
    create_table :article_types do |t|
      t.string :name, :null => false, :default => ""

      t.timestamps
    end
  end
end
