class Device < ActiveRecord::Base
  validates :uuid, :presence => true
  validates :uuid, :push_id, :uniqueness => true
  has_and_belongs_to_many :open_calls, :join_table => :open_call_participants
  has_many :responses, :dependent => :delete_all
end
