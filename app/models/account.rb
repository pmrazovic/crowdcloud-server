class Account < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :sensing_tasks, :as => :crowdsourcer, :dependent => :destroy
  has_many :hits, :as => :crowdsourcer, :dependent => :destroy
  validates :first_name, :last_name, :presence => true
end
