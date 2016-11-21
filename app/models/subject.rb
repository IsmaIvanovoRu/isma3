class Subject < ActiveRecord::Base
  belongs_to :attachment
  belongs_to :educational_program
  has_and_belongs_to_many :posts  
  validates :name, :attachment_id, :educational_program_id, presence: true
  validates :attachment_id, :educational_program_id, numericality: { integer_only: true }
end
