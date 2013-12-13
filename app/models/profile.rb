class Profile < ActiveRecord::Base
  belongs_to :user
  belongs_to :degree
  belongs_to :academic_title
  has_and_belongs_to_many :attachments
  
  validates :first_name, :last_name, :presence => true, 
            :length => { :maximum => 50 }
  def full_name
  [first_name, middle_name, last_name].compact.join(' ')
  end
  
end
