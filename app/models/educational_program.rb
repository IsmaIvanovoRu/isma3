class EducationalProgram < ActiveRecord::Base
  belongs_to :educational_standart
  belongs_to :accreditation
  belongs_to :attachment
  has_many :academic_plans, dependent: :destroy
  has_many :academic_schedules, dependent: :destroy
  has_many :practices, dependent: :destroy
  has_many :methodological_supports, dependent: :destroy
  has_many :subjects, dependent: :destroy
  has_many :posts, through: :subjects
  has_many :educational_program_numbers
  has_many :educational_program_priems
  has_many :educational_program_perevods
  has_many :educational_program_vacants
  has_many :educational_program_researches
  has_many :classrooms, through: :subjects
  has_many :marks
  
  validates :name, :level, :form, :duration, :attachment_id, :language, :year_start, presence: true
  validates :attachment_id, :year_start, numericality: { integer_only: true }
  
  def full_name
    if year_start > 2020 && level =~ /специалитет/
      "Образовательная программа высшего образования #{code} - #{name} (#{year_start}-#{year_start + duration.to_i})"
    else
      "Основная профессиональная образовательная программа высшего образования #{code} - #{name} (#{year_start}-#{year_start + duration.to_i})"
    end
  end
end
