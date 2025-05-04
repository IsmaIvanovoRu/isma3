class Criterium < ActiveRecord::Base
  has_many :efficients

  def self.import(file)
    # загружаем список критериев эффективного контракта
    file = open_spreadsheet(file)
    header = file.row(1)
    Criterium.update_all(actual: false)
    (2..file.last_row).to_a.each do |i|
      row = Hash[[header, file.row(i)].transpose]
      criterium = Criterium.find_or_create_by(chapter: row['Раздел'], point: row['Название критерия'])
      criterium.min = row['Минимальный балл'].to_f
      criterium.max = row['Максимальный балл'].to_f
      criterium.comment = row['Комментарий']
      criterium.criterium_type = case
                        when row['Комментарий'] =~ /Скан|скан/ && row['Комментарий'] =~ /Ссылка|ссылка/
                          'both'
                        when row['Комментарий'] =~ /Скан|скан/
                          'file'
                        when row['Комментарий'] =~ /Ссылка|ссылка/
                          'link'
                        else
                          'none'
                        end
      criterium.actual = true
      criterium.acceptor_type = row['Получатель']
      criterium.save!
    end
  end
  
  private
  
  def self.open_spreadsheet(file)
    Roo::CSV.new(file.path)
  end
end
