class Response < ActiveRecord::Base
  belongs_to :task, :polymorphic => true
  belongs_to :device
  has_many   :response_items, :dependent => :destroy
  validates :task, :device, :presence => true

  def responded_data_types
    response_items.collect{ |item| item.response_data_type }
  end
end
