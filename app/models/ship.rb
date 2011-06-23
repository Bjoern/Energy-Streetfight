class Ship < ActiveRecord::Base
  belongs_to :game
  belongs_to :destination, :class_name => "Island"
  has_many :users
  #-> see users #has_many :meter_readings
  belongs_to :resource #cargo
  has_many :votes
end
