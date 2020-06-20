class CreateJoinTablePostSubject < ActiveRecord::Migration
  def change
    create_join_table :posts, :subjects do |t|
      # t.index [:post_id, :subject_id]
      # t.index [:subject_id, :post_id]
    end
  end
end
