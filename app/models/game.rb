class Game < ActiveRecord::Base
    has_many :ships
    has_many :islands
    has_many :problems
    has_many :resources
    has_many :users    
end
