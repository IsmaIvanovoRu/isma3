class Menu < ActiveRecord::Base
  validates :location, :title, :path, :weigth, :presence => true
end
