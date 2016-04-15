class AcademicPlan < ActiveRecord::Base
  belongs_to :attachment
  belongs_to :educational_program
  validates :name, :attachment_id, :educational_program_id, presence: true
  validates :attachment_id, :educational_program_id, numericality: { integer_only: true }
end
