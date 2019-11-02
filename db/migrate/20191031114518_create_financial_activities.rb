class CreateFinancialActivities < ActiveRecord::Migration
  def change
    create_table :financial_activities do |t|
      t.integer :year
      t.decimal :federal_volume, default: 0.0, :precision => 16, :scale => 2
      t.decimal :regional_volume, default: 0.0, :precision => 16, :scale => 2
      t.decimal :municipal_volume, default: 0.0, :precision => 16, :scale => 2
      t.decimal :personal_volume, default: 0.0, :precision => 16, :scale => 2
      t.string :financial_report_link
      t.string :financial_plan_link
      t.string :bus_gov_link

      t.timestamps null: false
    end
  end
end
