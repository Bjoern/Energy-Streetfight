class Problem < ActiveRecord::Base
    belongs_to :game
    belongs_to :resource #the resource that resolves this problem
end
