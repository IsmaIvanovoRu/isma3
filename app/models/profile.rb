class Profile < ActiveRecord::Base
  belongs_to :user
  belongs_to :degree
  belongs_to :academic_title
  has_and_belongs_to_many :attachments
  
  validates :first_name, :last_name, :presence => true, 
            :length => { :maximum => 50 }
  
  def full_name
  [last_name, first_name, middle_name].compact.join(' ')
  end
  
  def full_name_reg
  "#{[last_name, first_name, middle_name].compact.join(' ')} - #{[(degree.short_name if degree), (academic_title.name if academic_title)].compact.join(', ')}"
  end
  
end
