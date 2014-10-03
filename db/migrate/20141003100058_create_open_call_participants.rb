class CreateOpenCallParticipants < ActiveRecord::Migration
  def change
    create_table :open_call_participants, :id => false do |t|
      t.references :device, :null => false
      t.references :open_call, :null => false
    end
    add_foreign_key :open_call_participants, :devices, :column => 'device_id'
    add_foreign_key :open_call_participants, :open_calls, :column => 'open_call_id'
    add_index :open_call_participants, :device_id
    add_index :open_call_participants, :open_call_id
  end
end
