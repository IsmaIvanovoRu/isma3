class EducationalProgramResearch < ActiveRecord::Base
  belongs_to :educational_program
  
  validates :perechen_nir, :date, presence: true
  validates :npr_nir, :stud_nir, :monograf_nir, :article_nir, :patent_r_nir, :patent_z_nir, :svid_r_nir, :svid_z_nir, :finance_nir, numericality: { integer_only: true }
  
  private
  
  def self.import(file)
    educational_program_codes = EducationalProgram.select(:id, :code).map{|ep| [ep.code, ep.id]}.to_h
    message = ''
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).to_a.in_groups_of(100, false) do |group|
      ActiveRecord::Base.transaction do
	group.each do |i|
	  row = Hash[[header, spreadsheet.row(i)].transpose]
	  educational_program_code = row["code"]
          educational_program_id = educational_program_codes[educational_program_code] if educational_program_codes.keys.include?(educational_program_code)
          if educational_program_id
            educational_program_research = new
            educational_program_research.attributes = row.to_hash.slice('perechen_nir', 'base_nir', 'npr_nir', 'stud_nir', 'monograf_nir', 'article_nir', 'patent_r_nir', 'patent_z_nir', 'svid_r_nir', 'svid_z_nir', 'finance_nir', 'date')
            educational_program_research.educational_program_id = educational_program_id
            educational_program_research.save
          end
	end
      end
    end
  end

  def self.open_spreadsheet(file)
    case File.extname(file.original_filename)
    when ".csv" then Roo::CSV.new(file.path)
    else raise "Unknown file type: #{file.original_filename}"
    end
  end
end
