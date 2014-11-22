class CreateSensingDataTypes < ActiveRecord::Migration
  def change
    create_table :sensing_data_types do |t|
      t.string :name, :null => false
      t.timestamps
    end
    add_index :sensing_data_types, :name, :unique => true
  end
end
