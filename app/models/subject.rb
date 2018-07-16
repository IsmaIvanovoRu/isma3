class Subject < ActiveRecord::Base
  belongs_to :attachment
  belongs_to :educational_program
  has_and_belongs_to_many :posts 
  has_many :classrooms
  
  validates :name, :educational_program_id, presence: true
  validates :educational_program_id, numericality: { integer_only: true }
end
