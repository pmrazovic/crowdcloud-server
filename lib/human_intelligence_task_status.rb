require 'enum'

class HumanIntelligenceTaskStatus < Enum
  HumanIntelligenceTaskStatus.add_item :STEP_1, 'PENDING'
  HumanIntelligenceTaskStatus.add_item :STEP_2, 'PENDING'
  HumanIntelligenceTaskStatus.add_item :STEP_3, 'PENDING'
  HumanIntelligenceTaskStatus.add_item :PENDING, 'PENDING'
  HumanIntelligenceTaskStatus.add_item :PUBLISHED, 'PUBLISHED'
  HumanIntelligenceTaskStatus.add_item :CLOSED, 'CLOSED'
end