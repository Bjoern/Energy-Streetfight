class Ship < ActiveRecord::Base
  belongs_to :game
  belongs_to :destination
  has_many :users
  #-> see users #has_many :meter_readings
  has_many :resources #cargo
  has_many :votes
end
