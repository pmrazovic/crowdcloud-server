class AddPushIdToDevices < ActiveRecord::Migration
  def change
    add_column :devices, :push_id, :string
    add_index :devices, :push_id, :unique => true
  end
end
