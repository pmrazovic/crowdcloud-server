class CreateSensingTaskDataTypes < ActiveRecord::Migration
  def change
    create_table :sensing_task_data_types, :id => false do |t|
      t.references :sensing_task, :null => false
      t.references :sensing_data_type, :null => false
    end
    add_foreign_key :sensing_task_data_types, :sensing_tasks, :column => 'sensing_task_id'
    add_foreign_key :sensing_task_data_types, :sensing_data_types, :column => 'sensing_data_type_id'
    add_index :sensing_task_data_types, :sensing_task_id
    add_index :sensing_task_data_types, :sensing_data_type_id
  end
end
