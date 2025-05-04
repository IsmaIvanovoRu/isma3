class AddColumnToFinancialActivity < ActiveRecord::Migration
  def change
    add_column :financial_activities, :fin_post, :decimal, default: 0.0, :precision => 16, :scale => 2
    add_column :financial_activities, :fin_ras, :decimal, default: 0.0, :precision => 16, :scale => 2
  end
end
