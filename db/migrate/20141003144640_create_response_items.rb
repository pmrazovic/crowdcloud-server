class CreateResponseItems < ActiveRecord::Migration
  def change
    create_table :response_items do |t|
      t.references :response, :null => false
      t.references :response_data, :polymorphic => true, :null => false
      t.timestamps
    end
    add_foreign_key :response_items, :responses, :column => 'response_id', :dependent => :delete_all
    add_index :response_items, :response_id
    add_index :response_items, [:response_data_id, :response_data_type]    
  end
end