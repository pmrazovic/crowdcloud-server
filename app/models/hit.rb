class Hit < ActiveRecord::Base
  validates :question, :presence => true
  belongs_to :crowdsourcer, :polymorphic => true, :dependent => :destroy
  has_and_belongs_to_many :sensing_data_types, :join_table => :context_data_types
  has_many :sensing_responses, :as => :task, :dependent => :destroy
  has_many :response_items, :through => :responses
  has_many :hit_choices, :dependent => :destroy
  has_many :hit_responses
end
