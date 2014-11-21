class CreateSensingResponseItems < ActiveRecord::Migration
  def change
    create_table :sensing_response_items do |t|
      t.references :sensing_response, :null => false
      t.references :sensing_response_data, :polymorphic => true, :null => false
      t.timestamps
    end
    add_foreign_key :sensing_response_items, :sensing_responses, :column => 'sensing_response_id', :dependent => :delete_all
    add_index :sensing_response_items, :sensing_response_id
    add_index :sensing_response_items, [:sensing_response_data_id, :sensing_response_data_type], :name => 'index_polymorphic_assc'
  end
end