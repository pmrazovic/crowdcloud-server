class HitChoice < ActiveRecord::Base
  belongs_to :human_intelligence_task
  validates :description, :presence => true
end
