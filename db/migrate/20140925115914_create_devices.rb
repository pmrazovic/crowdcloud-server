class CreateDevices < ActiveRecord::Migration
  def change
    create_table :devices do |t|
      t.string :uuid, :unique => true, :null => false
      t.string :platform
      t.string :model
      t.string :version
      t.timestamps
    end

    add_index :devices, :uuid, :unique => true
  end
end
