class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :trackable
  
  validates :login, :presence => true, 
            :length => { :maximum => 50 }, 
            :uniqueness => true
  validates :password, :confirmation => true,
	    :length => { :minimum => 8 },
	    :presence => true
  validates :password_confirmation, :presence => true
  
  has_one :profile, dependent: :destroy
  has_many :articles
  has_and_belongs_to_many :groups
  has_many :posts
  has_many :divisions, :through => :posts
  has_many :feedbacks
  has_many :comments
   
  after_create :add_default_groups, :build_default_profile
  
  private
  def add_default_groups
    groups << Group.where(name: 'readers')
  end
  
  def build_default_profile
    p = build_profile
    p.save!
  end
  
  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).each do |i|
      row = Hash[[header, spreadsheet.row(i)].transpose]
      user = find_by_id(row["id"]) || new
      if user.id
	user.profile.import(row)
      else
	user.attributes = row.to_hash.slice('login', 'password', 'password_confirmation')
	if user.save!
	  user.profile.import(row)
	end
      end
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
end
