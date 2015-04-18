class AddColumnsToDivision < ActiveRecord::Migration
  def change
    add_column :divisions, :url, :string, default: ''
    add_column :divisions, :reference, :integer
  end
end
