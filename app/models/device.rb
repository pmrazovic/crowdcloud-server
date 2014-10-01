class Device < ActiveRecord::Base
  validates :uuid, :platform, :version, :model, :push_id, :presence => true
  validates :uuid, :push_id, :uniqueness => true
end
