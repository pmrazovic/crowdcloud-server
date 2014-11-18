require 'enum'

class TaskType < Enum
  TaskType.add_item :SENSING, 'Sensing task'
  TaskType.add_item :HIT, 'Human intelligence task (HIT)'
end