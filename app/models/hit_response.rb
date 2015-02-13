class HitResponse < ActiveRecord::Base
  belongs_to :hit
  belongs_to :device
  belongs_to :hit_choice
  validates  :hit, :device, :presence => true
  has_one    :sensing_response, :as => :sensable, :dependent => :destroy
end
