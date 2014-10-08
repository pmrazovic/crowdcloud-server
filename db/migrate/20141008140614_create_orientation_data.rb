class CreateOrientationData < ActiveRecord::Migration
  def change
    create_table :orientation_data do |t|
      t.decimal  :magnetic_heading
      t.datetime :created_at
    end
  end
end
