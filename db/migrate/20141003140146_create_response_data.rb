class CreateResponseData < ActiveRecord::Migration
  def change
    create_table :response_data do |t|
      t.references :response
      t.timestamps
    end
    add_foreign_key :response_data, :responses, :column => 'response_id'
    add_index :response_data, :response_id
  end
end
