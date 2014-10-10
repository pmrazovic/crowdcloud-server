class CreateLightData < ActiveRecord::Migration
  def change
    create_table :light_data do |t|
      t.decimal  :lumen
      t.datetime :created_at
    end
  end
end
