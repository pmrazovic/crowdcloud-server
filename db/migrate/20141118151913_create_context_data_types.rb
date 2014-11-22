class CreateContextDataTypes < ActiveRecord::Migration
  def change
    create_table :context_data_types do |t|
      t.references :hit, :null => false
      t.references :sensing_data_type, :null => false
    end
    add_foreign_key :context_data_types, :hits, :column => 'hit_id'
    add_foreign_key :context_data_types, :sensing_data_types, :column => 'sensing_data_type_id'
    add_index :context_data_types, :hit_id
    add_index :context_data_types, :sensing_data_type_id
  end
end