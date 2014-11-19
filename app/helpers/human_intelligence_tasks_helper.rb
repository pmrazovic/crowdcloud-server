require 'human_intelligence_task_status'
module HumanIntelligenceTasksHelper
  def status_label_type(hit)
    case hit.status
    when HumanIntelligenceTaskStatus::PENDING.to_s
      "label-default"
    when HumanIntelligenceTaskStatus::PUBLISHED.to_s
      "label-success"
    when HumanIntelligenceTaskStatus::FINISHED.to_s
      "label-primary"
    end    
  end
end
