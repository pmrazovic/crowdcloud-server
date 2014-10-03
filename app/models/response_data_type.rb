class ResponseDataType < ActiveRecord::Base
  validates :name, :presence => true
  validates :name, :uniqueness => true
  has_and_belongs_to_many :open_calls, :join_table => :type_configurations
end
