class AddColumnsToProfile < ActiveRecord::Migration
  def change
    add_column :profiles, :discipline, :string, default: ''
    add_column :profiles, :qualification, :string, default: ''
    add_column :profiles, :development, :text
    add_column :profiles, :general_experience, :integer, default: 0
    add_column :profiles, :special_experience, :integer, default: 0
  end
end
