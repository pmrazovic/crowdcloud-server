class SensingResponse < ActiveRecord::Base
  belongs_to :sensable, :polymorphic => true
  belongs_to :device
  has_many   :sensing_response_items, :dependent => :destroy
  validates :sensable, :device, :presence => true

  def responded_data_types
    sensing_response_items.collect{ |item| item.sensing_response_data_type }
  end
end
