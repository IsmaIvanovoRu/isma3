class Post < ActiveRecord::Base
  belongs_to :user
  belongs_to :division
  belongs_to :parent, :foreign_key => "parent_id", :class_name => "Post"
  belongs_to :post_type
  has_many :feedbacks
  has_and_belongs_to_many :subjects
  has_many :educational_programs, through: :subjects
  has_one :profile, :through => :user
  
  validates :name, :division_id, :presence => true
  validates :name, :length => { :maximum => 255 }
  
  def is_head?
    parent.nil? || (parent.nil? ? false : parent.division != division)
  end
  
  def self.import_from_row(row, user)
    post = Division.find_by_name(row["name"]).posts.new
    post.name = row["post"]
    post.user_id = user.id
    post.parent_id = post.division.head.first.id unless post.division.head.empty?
    post.save!
  end
end
