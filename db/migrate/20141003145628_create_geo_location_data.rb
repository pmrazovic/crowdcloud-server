class CreateGeoLocationData < ActiveRecord::Migration
  def change
    create_table :geo_location_data do |t|
      t.decimal  :latitude, :precision => 10, :scale => 6
      t.decimal  :longitude, :precision => 10, :scale => 6
      t.decimal  :altitude, :precision => 6, :scale => 2
      t.integer  :accuracy
      t.integer  :altitude_accuracy
      t.integer  :heading
      t.decimal  :speed, :precision => 8, :scale => 2
      t.datetime :created_at
    end
  end
end
