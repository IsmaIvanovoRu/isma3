class Division < ActiveRecord::Base
  belongs_to :division_type
  has_many :posts
  has_many :users, :through => :posts
  has_many :profiles, :through => :users
  has_many :articles, :through => :users
  has_and_belongs_to_many :attachments
  
  validates :name, :presence => true, 
            :length => { :maximum => 255 }
  validates :latitude, :numericality => { :greater_than_or_equal_to => -90, :less_than_or_equal_to => 90 }
  validates :longitude, :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 180 }
  
  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      division = find_by_id(row["id"]) || new
      division.attributes = row.to_hash.slice('id', 'name', 'division_type_id', 'address', 'latitude', 'longitude', 'email')
      division.save!
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".ods" then Roo::Openoffice.new(file.path, nil, :ignore)
    when ".csv" then Roo::Csv.new(file.path, nil, :ignore)
    when ".xls" then Roo::Excel.new(file.path, nil, :ignore)
    when ".xlsx" then Roo::Excelx.new(file.path, nil, :ignore)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end
  
  def head
    posts.includes(:user).includes(:parent).select{|p| p.parent.nil? || p.parent.division_id != id}
  end
end
