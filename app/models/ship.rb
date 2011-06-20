class Ship < ActiveRecord::Base
  belongs_to :game
  belongs_to :destination
  has_many :users
  #-> see users #has_many :meter_readings
  belongs_to :resource #cargo
  has_many :votes
end
