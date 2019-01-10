class EducationalProgram < ActiveRecord::Base
  belongs_to :educational_standart
  belongs_to :accreditation
  belongs_to :attachment
  has_many :academic_plans, dependent: :destroy
  has_many :academic_schedules, dependent: :destroy
  has_many :practices, dependent: :destroy
  has_many :methodological_supports, dependent: :destroy
  has_many :subjects, dependent: :destroy
  has_many :educational_program_numbers
  has_many :educational_program_priems
  has_many :educational_program_perevods
  has_many :educational_program_vacants
  has_many :classrooms, through: :subjects
  
  validates :name, :level, :form, :duration, :attachment_id, presence: true
  validates :attachment_id, numericality: { integer_only: true }
  
  def full_name
    "Основная профессиональная образовательная программа высшего образования #{code} - #{name} (#{level}, #{form} форма обучения)"
  end
end
