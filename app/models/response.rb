class Response < ActiveRecord::Base
  validates :open_call, :device, :presence => true
  belongs_to :open_call
  belongs_to :device
  has_many   :response_items, :dependent => :destroy
end
