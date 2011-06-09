class User < ActiveRecord::Base
  belongs_to :ship
  has_many :meter_readings
  has_many :votes
end
