class EducationalProgramPerevod < ActiveRecord::Base
  belongs_to :educational_program

  validates :number_out_perevod, :number_to_perevod, :number_res_perevod, :number_exp_perevod, numericality: { integer_only: true }
  
  private
  
  def self.import(file)
    educational_program_codes = EducationalProgram.select(:id, :code).map{|ep| [ep.code, ep.id]}.to_h
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).to_a.in_groups_of(100, false) do |group|
      ActiveRecord::Base.transaction do
	group.each do |i|
	  row = Hash[[header, spreadsheet.row(i)].transpose]
	  educational_program_code = row["code"]
          educational_program_id = educational_program_codes[educational_program_code] if educational_program_codes.keys.include?(educational_program_code)
          if educational_program_id
            educational_program_perevod = new
            educational_program_perevod.attributes = row.to_hash.slice('number_out_perevod', 'number_to_perevod', 'number_res_perevod', 'number_exp_perevod', 'date')
            educational_program_perevod.educational_program_id = educational_program_id
            educational_program_perevod.save
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
