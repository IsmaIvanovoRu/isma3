class EducationalProgram < ActiveRecord::Base
  belongs_to :educational_standart
  belongs_to :accreditation
  belongs_to :attachment
  has_one :academic_plan
  has_one :academic_schedule
  has_many :practices
  has_many :methodological_supports
  has_many :subjects
  
  validates :name, :educational_standart, :level, :attachment_id, presence: true
  validates :attachment_id, :accreditation_id, :educational_standart_id, numericality: { integer_only: true }
end
