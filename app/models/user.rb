require 'digest/sha2'

class User < ActiveRecord::Base
    attr_accessible :firstName, :lastName, :team, :email

    validates_presence_of :code
    validates_uniqueness_of :code
    #validates_uniqueness_of :name
    
    belongs_to :ship
    has_many :meter_readings
    has_many :votes
end
