class Feedback < ActiveRecord::Base
  validates :question, :from, :to, :presence => true
  belongs_to :post, :foreign_key => "to", :class_name => "Post"
  belongs_to :user, :foreign_key => "from", :class_name => "User"
end
