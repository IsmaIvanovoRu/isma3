class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :trackable
  
  validates :login, :presence => true, 
            :length => { :maximum => 50 }, 
            :uniqueness => true
  validates :password, :confirmation => true,
	    :length => { :minimum => 8 },
	    :presence => true
  validates :password_confirmation, :presence => true
  
  has_one :profile, dependent: :destroy
  has_many :articles
  has_and_belongs_to_many :groups
  has_many :posts
  has_many :divisions, :through => :posts
   
  after_create :add_default_groups, :build_default_profile
  
  private
  def add_default_groups
    groups << Group.where(name: 'reader')
    groups << Group.where(name: 'guests')
  end
  
  def build_default_profile
    p = build_profile
    p.save!
  end
end
