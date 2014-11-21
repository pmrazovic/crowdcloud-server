class HitResponse < ActiveRecord::Base
  belongs_to :hit
  belongs_to :device
  belongs_to :hit_choice
  validates  :hit, :device, :presence => true
  has_many :sensing_responses, :as => :task, :dependent => :destroy
end
