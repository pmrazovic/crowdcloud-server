class CreateTypeConfiguration < ActiveRecord::Migration
  def change
    create_table :type_configurations, :id => false do |t|
      t.references :open_call
      t.references :response_data_type
    end
    add_foreign_key :type_configurations, :open_calls, :column => 'open_call_id'
    add_foreign_key :type_configurations, :response_data_types, :column => 'response_data_type_id'
    add_index :type_configurations, :open_call_id
    add_index :type_configurations, :response_data_type_id
  end
end
