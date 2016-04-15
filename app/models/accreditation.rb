class Accreditation < ActiveRecord::Base
  belongs_to :attachment
  has_many: :educational_programs
  validates :number, :date_of_issue, :attachment_id, presence: true
  validates :attachment_id, numericality: { integer_only: true }
end
