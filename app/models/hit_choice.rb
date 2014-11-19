class HitChoice < ActiveRecord::Base
  belongs_to :hit
  validates :description, :presence => true
end
