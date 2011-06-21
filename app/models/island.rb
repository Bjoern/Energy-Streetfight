class Island < ActiveRecord::Base
    belongs_to :game
    belongs_to :problem
    belongs_to :resource
end
