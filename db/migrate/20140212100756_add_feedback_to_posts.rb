class AddFeedbackToPosts < ActiveRecord::Migration
  def change
    add_column :posts, :feedback, :boolean, :null => false, :default => false
    Post.all.each{|p| p.update_attributes(feedback: false)}
  end
end
