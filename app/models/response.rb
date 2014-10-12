class Response < ActiveRecord::Base
  validates :open_call, :device, :presence => true
  belongs_to :open_call
  belongs_to :device
  has_many   :response_items, :dependent => :destroy

  def responded_data_types
    response_items.collect{ |item| item.response_data_type }
  end
end
