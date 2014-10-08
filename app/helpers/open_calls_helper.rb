require 'open_call_status'
module OpenCallsHelper

  def status_label_type(open_call)
    case open_call.status
    when OpenCallStatus::PENDING.to_s
      "label-default"
    when OpenCallStatus::PUBLISHED.to_s
      "label-success"
    when OpenCallStatus::FINISHED.to_s
      "label-primary"
    end    
  end

  def response_data_type_icon(response_data_type)
    case response_data_type.name
    when "GeoLocationData"
      '<i class="fa fa-globe"></i>'
    when "AcousticsData"
      '<i class="fa fa-microphone"></i>'
    when "IlluminationData"
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
