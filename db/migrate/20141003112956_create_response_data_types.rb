class CreateResponseDataTypes < ActiveRecord::Migration
  def change
    create_table :response_data_types do |t|
      t.string :name
      t.timestamps
    end
  end
end
