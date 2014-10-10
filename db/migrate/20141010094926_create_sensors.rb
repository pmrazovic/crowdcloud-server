class CreateSensors < ActiveRecord::Migration
  def change
    create_table :sensors do |t|
      t.references  :device
      t.string      :vendor
      t.string      :name
      t.string      :sensor_type
      t.string      :version
      t.decimal     :max_range
      t.decimal     :power
      t.decimal     :resolution
    end
    add_foreign_key :sensors, :devices, :column => 'device_id'
    add_index :sensors, :device_id
  end
end
