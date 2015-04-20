class Profile < ActiveRecord::Base
  belongs_to :user
  has_many :posts, :through => :user
  has_many :divisions, :through => :posts
  belongs_to :degree
  belongs_to :academic_title
  has_and_belongs_to_many :attachments
  
  validates :first_name, :last_name, :middle_name, :length => { :maximum => 50 }
  
  def full_name
  [last_name, first_name, middle_name].compact.join(' ').strip
  end
  
  def full_name_reg
  full_name + (reg.empty? ? "" : " - #{reg}" )
  end
  
  def reg
    deg = degree.short_name if degree
    ac = academic_title.name if academic_title
    [deg, ac].compact.join(', ').strip
  end
  
  def import(row)
    self.attributes = row.to_hash.slice('last_name', 'first_name', 'middle_name', 'email', 'phone')
    self.academic_title = AcademicTitle.find_by_name(row["academic_title"]) if row["academic_title"]
    self.degree = Degree.find_by_name(row["degree"]) if row["degree"]
    self.save!
  end

  def open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".ods" then Roo::Openoffice.new(file.path, nil, :ignore)
    when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
    when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end
end
