class MotionData < ActiveRecord::Base
  has_one :response_item, :as => :response_data
end
