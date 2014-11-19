class CreateContextDataTypes < ActiveRecord::Migration
  def change
    create_table :context_data_types do |t|
      t.references :human_intelligence_task, :null => false
      t.references :response_data_type, :null => false
    end
    add_foreign_key :context_data_types, :human_intelligence_tasks, :column => 'human_intelligence_task_id'
    add_foreign_key :context_data_types, :response_data_types, :column => 'response_data_type_id'
    add_index :context_data_types, :human_intelligence_task_id
    add_index :context_data_types, :response_data_type_id
  end
end