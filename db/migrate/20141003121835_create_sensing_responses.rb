class CreateSensingResponses < ActiveRecord::Migration
  def change
    create_table :sensing_responses do |t|
      t.references :sensable, :polymorphic => true, :null => false
      t.references :device, :null => false
      t.datetime   :created_at
    end
    add_foreign_key :sensing_responses, :devices, :column => 'device_id'
    add_index :sensing_responses, :device_id
    add_index :sensing_responses, [:sensable_id, :sensable_type]
  end
end
