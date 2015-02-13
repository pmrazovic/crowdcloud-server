class CreateBackgroundTracks < ActiveRecord::Migration
  def change
    create_table :background_tracks do |t|
      t.references :device
      t.decimal  :bearing
      t.decimal  :latitude
      t.decimal  :longitude
      t.decimal  :altitude
      t.integer  :accuracy
      t.decimal  :speed
      t.datetime :recorded_at
      t.datetime :created_at
    end
    add_foreign_key :background_tracks, :devices, :column => 'device_id'
    add_index :background_tracks, :device_id
  end
end