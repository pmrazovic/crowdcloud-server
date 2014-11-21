require 'hit_status'
module HitsHelper
  def hit_status_label_type(hit)
    case hit.status
    when HitStatus::PENDING.to_s
      '<span class="label label-default">PENDING</span>'.html_safe
    when HitStatus::STEP_1.to_s
      '<span class="label label-default">PENDING</span>'.html_safe
    when HitStatus::STEP_2.to_s
      '<span class="label label-default">PENDING</span>'.html_safe
    when HitStatus::STEP_3.to_s
      '<span class="label label-default">PENDING</span>'.html_safe
    when HitStatus::PUBLISHED.to_s
      '<span class="label label-success">PUBLISHED</span>'.html_safe
    when HitStatus::CLOSED.to_s
      '<span class="label label-primary">CLOSED</span>'.html_safe
    end    
  end
end
