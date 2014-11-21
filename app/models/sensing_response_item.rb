class SensingResponseItem < ActiveRecord::Base
  validates :sensing_response, :sensing_response_data, :presence => true
  belongs_to :sensing_response
  belongs_to :sensing_response_data, :polymorphic => true, :dependent => :destroy
end
