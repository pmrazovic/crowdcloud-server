require 'enum'

class HumanIntelligenceTaskStatus < Enum
  HumanIntelligenceTaskStatus.add_item :PENDING, 'PENDING'
  HumanIntelligenceTaskStatus.add_item :PUBLISHED, 'PUBLISHED'
  HumanIntelligenceTaskStatus.add_item :FINISHED, 'FINISHED'
end