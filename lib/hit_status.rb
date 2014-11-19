require 'enum'

class HitStatus < Enum
  HitStatus.add_item :STEP_1, 'PENDING'
  HitStatus.add_item :STEP_2, 'PENDING'
  HitStatus.add_item :STEP_3, 'PENDING'
  HitStatus.add_item :PENDING, 'PENDING'
  HitStatus.add_item :PUBLISHED, 'PUBLISHED'
  HitStatus.add_item :CLOSED, 'CLOSED'
end