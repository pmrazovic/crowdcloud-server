class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :uuid, :null => false
      t.string :platform
      t.string :model
      t.string :version
      t.string :push_id
      t.timestamps
    end
    add_index :devices, :uuid, :unique => true
    add_index :devices, :push_id, :unique => true
  end
end
