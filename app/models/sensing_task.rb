class SensingTask < ActiveRecord::Base
  validates :name, :description, :presence => true
  belongs_to :account
  has_and_belongs_to_many :response_data_types, :join_table => :sensing_data_types
  has_many :responses, :as => :task, :dependent => :destroy
  has_many :response_items, :through => :responses
end