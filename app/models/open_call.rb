class OpenCall < ActiveRecord::Base
  validates :name, :description, :presence => true
  belongs_to :account
  has_and_belongs_to_many :devices, :join_table => :open_call_participants
  has_and_belongs_to_many :response_data_types, :join_table => :type_configurations
  has_many :responses, :dependent => :destroy
  has_many :response_items, :through => :responses
end
