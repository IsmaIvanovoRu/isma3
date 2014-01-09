class AddEmailToDivisions < ActiveRecord::Migration
  def change
    add_column :divisions, :email, :string, :default => ""
  end
end
