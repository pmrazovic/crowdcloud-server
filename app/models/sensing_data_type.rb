class SensingDataType < ActiveRecord::Base
  validates :name, :presence => true
  validates :name, :uniqueness => true
  has_and_belongs_to_many :sensing_tasks, :join_table => :sensing_task_data_types
end
