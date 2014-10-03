class CreateSensorDataTypes < ActiveRecord::Migration
  def change
    create_table :sensor_data_types do |t|
      t.string :name
      t.timestamps
    end
  end
end
