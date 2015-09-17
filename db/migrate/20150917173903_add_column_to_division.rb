class AddColumnToDivision < ActiveRecord::Migration
  def change
    add_column :divisions, :in_structure, :boolean, default: true
  end
end
