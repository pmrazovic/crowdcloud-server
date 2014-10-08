# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

Account.find_or_create_by(:email => 'admin@crowdcloud.com') do |account|
  account.password = 'password'
  account.confirmed_at = Time.now
end

ResponseDataType.find_or_create_by(:name => 'GeoLocationData')
ResponseDataType.find_or_create_by(:name => 'DeviceMotionData')
ResponseDataType.find_or_create_by(:name => 'OrientationData')
ResponseDataType.find_or_create_by(:name => 'TemperatureData')
ResponseDataType.find_or_create_by(:name => 'IlluminationData')
ResponseDataType.find_or_create_by(:name => 'AirPressureData')
ResponseDataType.find_or_create_by(:name => 'AcousticsData')