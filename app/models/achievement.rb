class Achievement < ActiveRecord::Base
  belongs_to :user
  belongs_to :achievement_category
  belongs_to :achievement_result
  has_and_belongs_to_many :attachments, dependent: :destroy
  
  validates :event_name, :achievement_category_id, :achievement_result_id, :event_date, presence: true
end
