require 'account_role'

Account.find_or_create_by(:email => 'admin@crowdcloud.com') do |account|
  account.first_name = 'Admin'
  account.last_name = 'Administratovic'
  account.password = 'password'
  account.role = AccountRole::ADMINISTRATOR.to_s
  account.confirmed_at = Time.now
end

SensingDataType.find_or_create_by(:name => 'GeoLocationData', :enabled => true)
SensingDataType.find_or_create_by(:name => 'MotionData', :enabled => true)
SensingDataType.find_or_create_by(:name => 'OrientationData', :enabled => true)
SensingDataType.find_or_create_by(:name => 'TemperatureData', :enabled => false)
SensingDataType.find_or_create_by(:name => 'LightData', :enabled => true)
SensingDataType.find_or_create_by(:name => 'AirPressureData', :enabled => false)
SensingDataType.find_or_create_by(:name => 'AcousticsData', :enabled => false)