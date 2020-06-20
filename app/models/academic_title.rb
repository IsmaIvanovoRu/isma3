class AcademicTitle < ActiveRecord::Base
  has_many :profiles
  has_many :users, :through => :profiles
  
  validates :name, :presence => true, 
            :length => { :maximum => 50 }, 
            :uniqueness => true
end
