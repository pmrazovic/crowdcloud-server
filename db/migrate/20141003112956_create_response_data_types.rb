class CreateResponseDataTypes < ActiveRecord::Migration
  def change
    create_table :response_data_types do |t|
      t.string :name, :null => false
      t.timestamps
    end
    add_index :response_data_types, :name, :unique => true
  end
end
