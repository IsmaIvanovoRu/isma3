class AddCommentToEfficient < ActiveRecord::Migration
  def change
    add_column :efficients, :comment, :text
  end
end
