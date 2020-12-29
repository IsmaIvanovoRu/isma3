class Classroom < ActiveRecord::Base
  belongs_to :subject
  
  validates :description, :location, :equipment, presence: true
  
  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    accessible_attributes = column_names
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      classrooms = Classroom.all
      classroom = classrooms.find_by_description(row['description'].strip) || classrooms.new(row.slice(*accessible_attributes))
      classroom.save!
    end
  end
  
  private
  
  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".ods" then Roo::Openoffice.new(file.path)
    when ".csv" then Roo::CSV.new(file.path)
    when ".xls" then Roo::Excel.new(file.path)
    when ".xlsx" then Roo::Excelx.new(file.path)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end
end
