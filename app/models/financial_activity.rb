class FinancialActivity < ActiveRecord::Base
  validates :year, presence: true
  validates :year, numericality: { integer_only: true }
  validates :year, uniqueness: true
  validates :federal_volume, :regional_volume, :municipal_volume, :personal_volume, numericality: true
end
