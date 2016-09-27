class EducationalProgram < ActiveRecord::Base
  belongs_to :educational_standart
  belongs_to :accreditation
  belongs_to :attachment
  has_many :academic_plans, dependent: :destroy
  has_many :academic_schedules, dependent: :destroy
  has_many :practices, dependent: :destroy
  has_many :methodological_supports, dependent: :destroy
  has_many :subjects, dependent: :destroy
  
  validates :name, :level, :form, :duration, :attachment_id, presence: true
  validates :attachment_id, numericality: { integer_only: true }
end
