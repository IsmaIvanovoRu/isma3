class AddColumnToSubject < ActiveRecord::Migration
  def change
    add_reference :subjects, :full_text_attachment, index: true
  end
end
