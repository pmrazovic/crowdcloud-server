require 'enum'

class SensingTaskStatus < Enum
  SensingTaskStatus.add_item :PENDING, 'PENDING'
  SensingTaskStatus.add_item :PUBLISHED, 'PUBLISHED'
  SensingTaskStatus.add_item :FINISHED, 'FINISHED'
end