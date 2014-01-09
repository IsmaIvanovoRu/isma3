class AddParentIdToMenus < ActiveRecord::Migration
  def change
    add_reference :menus, :parent, index: true
  end
end
