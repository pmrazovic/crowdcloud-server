class CreateGeoLocationData < ActiveRecord::Migration
  def change
    create_table :geo_location_data do |t|
      t.decimal  :latitude, :precision => 10, :scale => 6
      t.decimal  :longitude, :precision => 10, :scale => 6
      t.datetime :created_at
    end
  end
end
