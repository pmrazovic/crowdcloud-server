class Response < ActiveRecord::Base
  belongs_to :open_call
  belongs_to :device
end
