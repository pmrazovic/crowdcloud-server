class SensorDataType < ActiveRecord::Base
  has_and_belongs_to_many :open_calls, :join_table => :type_configurations
end
