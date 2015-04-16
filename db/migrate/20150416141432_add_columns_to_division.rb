class AddColumnsToDivision < ActiveRecord::Migration
  def change
    add_column :divisions, :url, :string
    add_column :divisions, :reference, :numeric
  end
end
