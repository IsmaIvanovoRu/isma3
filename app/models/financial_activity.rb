class FinancialActivity < ActiveRecord::Base
  validates :year, :federal_volume, :regional_volume, :municipal_volume, :personal_volume, :financial_report_link, :financial_plan_link, :bus_gov_link, presence: true
  validates :year, numericality: { integer_only: true }
  validates :year, uniqueness: true
  validates :federal_volume, :regional_volume, :municipal_volume, :personal_volume, numericality: true
end
