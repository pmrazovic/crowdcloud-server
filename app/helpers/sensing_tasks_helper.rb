require 'sensing_task_status'
module SensingTasksHelper

  def sensing_status_label_type(sensing_task)
    case sensing_task.status
    when SensingTaskStatus::PENDING.to_s
      "label-default"
    when SensingTaskStatus::PUBLISHED.to_s
      "label-success"
    when SensingTaskStatus::FINISHED.to_s
      "label-primary"
    end    
  end
end
