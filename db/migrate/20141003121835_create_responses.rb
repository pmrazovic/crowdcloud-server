class CreateResponses < ActiveRecord::Migration
  def change
    create_table :responses do |t|
      t.references :task, :polymorphic => true, :null => false
      t.references :device, :null => false
      t.datetime   :created_at
    end
    add_foreign_key :responses, :devices, :column => 'device_id'
    add_index :responses, :device_id
    add_index :responses, [:task_id, :task_type]
  end
end
