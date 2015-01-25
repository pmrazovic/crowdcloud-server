class SensingTask < ActiveRecord::Base
  validates :name, :description, :presence => true
  belongs_to :crowdsourcer, :polymorphic => true, :dependent => :destroy
  has_and_belongs_to_many :sensing_data_types, :join_table => :sensing_task_data_types
  has_many :sensing_responses, :as => :sensable, :dependent => :destroy
  has_many :sensing_response_items, :through => :responses
end
