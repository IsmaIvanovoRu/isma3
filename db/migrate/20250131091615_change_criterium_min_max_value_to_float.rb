class ChangeCriteriumMinMaxValueToFloat < ActiveRecord::Migration
  def up
    change_column :criteria, :min, :float, default: 0.0
    change_column :criteria, :max, :float, default: 0.0
  end

  def down
    change_column :criteria, :min, :integer, default: 0.0
    change_column :criteria, :max, :integer, default: 0.0
  end
end
