class CreateInternationalContracts < ActiveRecord::Migration
  def change
    create_table :international_contracts do |t|
      t.string :state_name
      t.string :org_name
      t.string :dog_name
      t.string :dog_number
      t.date :dog_date
      t.date :dog_date_end

      t.timestamps null: false
    end
  end
end
