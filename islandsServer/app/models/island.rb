class Island < ActiveRecord::Base
    belongs_to :game
    has_one :problem
    has_many :resources
end
