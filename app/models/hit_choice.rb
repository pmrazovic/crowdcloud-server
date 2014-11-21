class HitChoice < ActiveRecord::Base
  belongs_to :hit
  validates :description, :presence => true
  validates :description, :uniqueness => {:scope => :hit_id}
end
