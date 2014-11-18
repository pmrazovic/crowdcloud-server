class Device < ActiveRecord::Base
  validates :uuid, :presence => true
  validates :uuid, :push_id, :uniqueness => true
  has_many :responses
  has_many :response_items, :through => :responses
  has_many :sensors, :dependent => :destroy

  def has_sensor?(sensor_type)
    self.sensors.collect{|s| s.sensor_type }.include?(sensor_type)
  end
end
