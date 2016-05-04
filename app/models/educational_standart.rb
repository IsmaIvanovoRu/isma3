class EducationalStandart < ActiveRecord::Base
  has_one :educational_program, dependent: :destroy
  validates :name, :level, :url, presence: true
end
