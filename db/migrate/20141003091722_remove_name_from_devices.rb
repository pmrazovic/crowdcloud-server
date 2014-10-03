class RemoveNameFromDevices < ActiveRecord::Migration
  def change
    remove_column :devices, :name
  end
end
