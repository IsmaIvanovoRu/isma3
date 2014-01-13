class Division < ActiveRecord::Base
  belongs_to :division_type
  has_many :posts
  has_many :users, :through => :posts
  has_many :articles
  has_many :articles, :through => :users
    
  validates :name, :presence => true, 
            :length => { :maximum => 255 }
  validates :latitude, :numericality => { :greater_than_or_equal_to => -90, :less_than_or_equal_to => 90 }
  validates :longitude, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 180 }
end
