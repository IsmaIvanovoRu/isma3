class Group < ActiveRecord::Base
  has_and_belongs_to_many :users
  has_many :profiles, :through => :users
  has_many :articles, :through => :users
  belongs_to :parent, :foreign_key => "parent_id", :class_name => "Group"
  validates :name, :presence => true
end
