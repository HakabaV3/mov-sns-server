class CreateInvitations < ActiveRecord::Migration
  def change
    create_table :invitations do |t|
      t.references :group,  index: true, null: false
      t.integer :owner_id,  index: true, null: false
      t.integer :target_id, index: true, null: false

      t.timestamps
    end
  end
end
