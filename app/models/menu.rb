class Menu < ActiveRecord::Base
  belongs_to :parent, :foreign_key => "parent_id", :class_name => "Menu"
  validates :location, :title, :path, :weigth, :presence => true
end
