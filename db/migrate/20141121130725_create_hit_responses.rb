class CreateHitResponses < ActiveRecord::Migration
  def change
    create_table :hit_responses do |t|
      t.references :hit
      t.references :hit_choice
      t.references :device
      t.datetime   :created_at
    end
    add_foreign_key :hit_responses, :hits, :column => 'hit_id'
    add_foreign_key :hit_responses, :hit_choices, :column => 'hit_choice_id'
    add_foreign_key :hit_responses, :devices, :column => 'device_id'
    add_index :hit_responses, :hit_id
    add_index :hit_responses, :hit_choice_id
    add_index :hit_responses, :device_id
  end
end
