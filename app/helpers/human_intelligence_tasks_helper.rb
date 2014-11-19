require 'human_intelligence_task_status'
module HumanIntelligenceTasksHelper
  def hit_status_label_type(hit)
    case hit.status
    when HumanIntelligenceTaskStatus::PENDING.to_s
      '<span class="label label-default">PENDING</span>'.html_safe
    when HumanIntelligenceTaskStatus::STEP_1.to_s
      '<span class="label label-default">PENDING</span>'.html_safe
    when HumanIntelligenceTaskStatus::STEP_2.to_s
      '<span class="label label-default">PENDING</span>'.html_safe
    when HumanIntelligenceTaskStatus::STEP_3.to_s
      '<span class="label label-default">PENDING</span>'.html_safe
    when HumanIntelligenceTaskStatus::PUBLISHED.to_s
      '<span class="label label-success">PENDING</span>'.html_safe
    when HumanIntelligenceTaskStatus::FINISHED.to_s
      '<span class="label label-primary">PENDING</span>'.html_safe
    end    
  end
end
