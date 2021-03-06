class Device < ActiveRecord::Base
  validates :uuid, :presence => true
  validates :uuid, :push_id, :uniqueness => true
  has_many :sensing_tasks, :as => :crowdsourcer, :dependent => :destroy
  has_many :hits, :as => :crowdsourcer, :dependent => :destroy
  has_many :sensing_responses, :dependent => :destroy
  has_many :sensing_response_items, :through => :responses
  has_many :hit_responses, :dependent => :destroy
  has_many :sensors, :dependent => :destroy
  has_many :background_tracks, :dependent => :destroy

  def has_sensor?(sensor_type)
    self.sensors.collect{|s| s.sensor_type }.include?(sensor_type)
  end
end
