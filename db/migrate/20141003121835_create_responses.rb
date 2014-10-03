class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.references :open_call, :null => false
      t.references :device, :null => false
      t.datetime   :created_at
    end
    add_foreign_key :responses, :devices, :column => 'device_id'
    add_foreign_key :responses, :open_calls, :column => 'open_call_id'
    add_index :responses, :device_id
    add_index :responses, :open_call_id
  end
end
