class CreateFeedbacks < ActiveRecord::Migration
  def change
    create_table :feedbacks do |t|
      t.integer :to, :null => false
      t.integer :from, :null => false
      t.text :question
      t.text :answer
      t.boolean :public, :null => false, :default => false

      t.timestamps
    end
  end
end
