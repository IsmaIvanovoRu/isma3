class EducationalStandart < ActiveRecord::Base
  has_one :educational_program
  validates :name, :level, :url, presence: true
end
