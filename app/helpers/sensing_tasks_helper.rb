require 'sensing_task_status'
module SensingTasksHelper

  def status_label_type(sensing_task)
    case sensing_task.status
    when SensingTaskStatus::PENDING.to_s
      "label-default"
    when SensingTaskStatus::PUBLISHED.to_s
      "label-success"
    when SensingTaskStatus::FINISHED.to_s
      "label-primary"
    end    
  end

  def response_data_type_icon(response_data_type_name)
    case response_data_type_name
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
