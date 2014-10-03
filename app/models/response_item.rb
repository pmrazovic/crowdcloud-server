class ResponseItem < ActiveRecord::Base
  validates :response, :response_data, :presence => true
  belongs_to :response
  belongs_to :response_data, :polymorphic => true, :dependent => :destroy
end
