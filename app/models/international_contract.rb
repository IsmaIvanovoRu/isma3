class InternationalContract < ActiveRecord::Base
  
  def dog_reg
    [(dog_name if dog_name), ("№ #{dog_number}" if dog_number), ("от #{dog_date}" if dog_date), "срок действия: #{(dog_date_end ? dog_date_end : 'бессрочно')}"].compact.join(', ')
  end
  
  private
  
  def self.import(file)
    message = ''
    spreadsheet = open_spreadsheet(file)
    header = spreadsheet.row(1)
    (2..spreadsheet.last_row).to_a.in_groups_of(100, false) do |group|
      ActiveRecord::Base.transaction do
	group.each do |i|
	  row = Hash[[header, spreadsheet.row(i)].transpose]
          international_contract = new
          international_contract.attributes = row.to_hash.slice('state_name', 'org_name', 'dog_name', 'dog_date', 'dog_date_end', 'dog_number')
          international_contract.save
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
