class CreateMotionData < ActiveRecord::Migration
  def change
    create_table :motion_data do |t|
      t.decimal  :acceleration_x
      t.decimal  :acceleration_y
      t.decimal  :acceleration_z
      t.datetime :created_at
    end
  end
end
