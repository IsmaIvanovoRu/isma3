class CreatePostTypes < ActiveRecord::Migration
  def change
    create_table :post_types do |t|
      t.string :name, :null => false, :default => ""

      t.timestamps
    end
  end
end
