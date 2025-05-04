class AddColumnToCriterium < ActiveRecord::Migration
  def change
    add_column :criteria, :acceptor_type, :string
  end
end
