class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :division
  belongs_to :parent, :foreign_key => "parent_id", :class_name => "Post"
  belongs_to :post_type
  has_many :feedbacks
  
  validates :name, :division_id, :presence => true
  validates :name, :length => { :maximum => 255 }
  
  def is_head?
    parent.nil? || (parent.nil? ? false : parent.division != division)
  end
end
