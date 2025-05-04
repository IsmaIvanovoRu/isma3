class ChangeEfficientValueToFloat < ActiveRecord::Migration
  def up
    change_column :efficients, :value, :float, default: 0.0
  end

  def down
    change_column :efficients, :value, :integer, default: 0
  end
end
