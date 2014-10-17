require 'account_role'

Account.find_or_create_by(:email => 'admin@crowdcloud.com') do |account|
  account.first_name = 'Admin'
  account.last_name = 'Administratovic'
  account.password = 'password'
  account.role = AccountRole::ADMINISTRATOR.to_s
  account.confirmed_at = Time.now
end

ResponseDataType.find_or_create_by(:name => 'GeoLocationData')
ResponseDataType.find_or_create_by(:name => 'MotionData')
ResponseDataType.find_or_create_by(:name => 'OrientationData')
ResponseDataType.find_or_create_by(:name => 'TemperatureData')
ResponseDataType.find_or_create_by(:name => 'LightData')
ResponseDataType.find_or_create_by(:name => 'AirPressureData')
ResponseDataType.find_or_create_by(:name => 'AcousticsData')