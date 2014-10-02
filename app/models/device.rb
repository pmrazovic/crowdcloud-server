class Device < ActiveRecord::Base
  validates :uuid, :presence => true
  validates :uuid, :push_id, :uniqueness => true
end
