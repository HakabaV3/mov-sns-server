class AddOwnerIdToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :owner_id, :integer, null: false
  end
end
