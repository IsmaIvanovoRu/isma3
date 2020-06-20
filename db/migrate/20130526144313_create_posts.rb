class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.references :user, index: true
      t.references :division, index: true
      t.references :parent, index: true
      t.references :post_type, index: true
      t.string :name, :null => false, :default => ""

      t.timestamps
    end
  end
end
