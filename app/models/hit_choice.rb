class HitChoice < ActiveRecord::Base
  belongs_to :hit
  has_many   :hit_responses, :dependent => :destroy
  validates :description, :presence => true
  validates :description, :uniqueness => {:scope => :hit_id}
end
