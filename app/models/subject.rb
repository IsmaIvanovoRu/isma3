class Subject < ActiveRecord::Base
  belongs_to :annotation_attachment, class_name: "Attachment", foreign_key: "annotation_attachment_id"
  belongs_to :full_text_attachment, class_name: "Attachment", foreign_key: "full_text_attachment_id"
  belongs_to :educational_program
  has_and_belongs_to_many :posts
  has_many :classrooms, dependent: :destroy
  
  validates :name, :educational_program_id, presence: true
  validates :educational_program_id, numericality: { integer_only: true }
end
