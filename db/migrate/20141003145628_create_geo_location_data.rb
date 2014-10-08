class CreateGeoLocationData < ActiveRecord::Migration
  def change
    create_table :geo_location_data do |t|
      t.decimal  :latitude
      t.decimal  :longitude
      t.decimal  :altitude
      t.integer  :accuracy
      t.integer  :altitude_accuracy
      t.integer  :heading
      t.decimal  :speed
      t.datetime :created_at
    end
  end
end
