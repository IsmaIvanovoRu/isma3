class MethodologicalSupport < ActiveRecord::Base
  belongs_to :attachment
  belongs_to :educational_program
  
  validates :attachment_id, :educational_program_id, presence: true,
                                                      numericality: { integer_only: true }
end
