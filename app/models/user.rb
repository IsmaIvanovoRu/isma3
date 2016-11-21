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
  has_many :subjects, through: :posts
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
    (2..spreadsheet.last_row).to_a.in_groups_of(100, false) do |group|
      ActiveRecord::Base.transaction do
	group.each do |i|
	  row = Hash[[header, spreadsheet.row(i)].transpose]
	  user = find_by_login(row["login"]) || new
	  if user.id
	    user.profile.import(row)
	      if row['name']
		Division.import_from_row(row, user)
	      end
	  else
	    user.attributes = row.to_hash.slice('login', 'password', 'password_confirmation')
	    user_groups = row.to_hash.slice('groups')['groups'].split(',') if row.to_hash.slice('groups')['groups']
	    user_post = row.to_hash.slice('post')['post']
	    if user.save!
	      user.profile.import(row)
	      if user_groups
		user_groups.each{|group| user.groups << Group.where(name: group)}
	      end
	      if row['name']
		  Division.import_from_row(row, user)
	      end
	    end
	  end
	end
      end
    end
  end

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
