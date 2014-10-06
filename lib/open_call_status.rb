require 'enum'

class OpenCallStatus < Enum
  OpenCallStatus.add_item :PENDING, 'PENDING'
  OpenCallStatus.add_item :PUBLISHED, 'PUBLISHED'
  OpenCallStatus.add_item :FINISHED, 'FINISHED'
end