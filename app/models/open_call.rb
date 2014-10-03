class OpenCall < ActiveRecord::Base
  belongs_to :account
  has_and_belongs_to_many :devices, :join_table => :open_call_participants
  has_and_belongs_to_many :resposne_data_types, :join_table => :type_configurations
  has_many :responses, :dependent => :destroy
  has_many :response_items, :through => :responses
end
