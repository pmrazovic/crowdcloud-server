class CreateSensingDataTypes < ActiveRecord::Migration
  def change
    create_table :sensing_data_types, :id => false do |t|
      t.references :sensing_task, :null => false
      t.references :response_data_type, :null => false
    end
    add_foreign_key :sensing_data_types, :sensing_tasks, :column => 'sensing_task_id'
    add_foreign_key :sensing_data_types, :response_data_types, :column => 'response_data_type_id'
    add_index :sensing_data_types, :sensing_task_id
    add_index :sensing_data_types, :response_data_type_id
  end
end
