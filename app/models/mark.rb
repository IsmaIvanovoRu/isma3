class Mark < ActiveRecord::Base
  belongs_to :user
  belongs_to :educational_program
  has_many :groups, through: :user
  has_one :profile, through: :user
  
  validates :user_id, :educational_program_id, :subject, :value, presence: true
  validates :value, numericality: { integer_only: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  
  private
  
  def self.import(file)
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    students = load_users(['students', 'graduates'])
    common_columns = 6
    (2..spreadsheet.last_row).to_a.in_groups_of(100, false) do |group|
      ActiveRecord::Base.transaction do
	group.each do |i|
	  row = Hash[[header, spreadsheet.row(i)].transpose]
          if row.select{|k, v| v != nil}.length > common_columns
            unless row['Имя пользователя']
              logins = student_login(row)
              student = nil
              logins.each do |login|
                student ||= students.find_by_login(login)
              end
            else
              student = students.find_by_login(login)
            end
            if student
              educational_program_id = row['Направление (специальность)']
              common_columns.times do
                row.shift
              end
              row.select{|k, v| v != nil}.each do |subject, value|
                mark = student.marks.find_by_subject(subject) || student.marks.new
                mark.educational_program_id = educational_program_id
                mark.subject = subject
                mark.value = value
                mark.save
              end
            end
          end
	end
      end
    end
  end
  
  def self.load_users(group)
    User.includes(:profile).joins(:groups).where(groups: {name: group}).select(:id, :login)
  end
  
  def self.student_login(row)
    educational_program = EducationalProgram.find(row['Направление (специальность)'])
    if educational_program
      case educational_program.name
      when 'Лечебное дело'
        ["inter#{row['Зачетная книга']}", "lech#{row['Зачетная книга']}", "l#{row['Зачетная книга']}"]
      when 'Педиатрия'
        ["ped#{row['Зачетная книга']}", "p#{row['Зачетная книга']}"]
      when 'Стоматология'
        ["stomat#{row['Зачетная книга']}", "s#{row['Зачетная книга']}"]
      else
        []
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
