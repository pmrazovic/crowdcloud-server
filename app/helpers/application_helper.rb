module ApplicationHelper
  def sensing_data_type_icon(sensing_data_type_name)
    case sensing_data_type_name
    when "GeoLocationData"
      '<i class="fa fa-globe"></i>'
    when "AcousticsData"
      '<i class="fa fa-microphone"></i>'
    when "LightData"
      '<i class="fa fa-lightbulb-o"></i>'
    when "OrientationData"
      '<i class="fa fa-compass"></i>'
    when "MotionData"
      '<i class="fa fa-tachometer"></i>'
    when "TemperatureData"
      '<i class="fa fa-sun-o"></i>'
    when "AirPressureData"
      '<i class="fa fa-cloud"></i>'
    end
  end
end
