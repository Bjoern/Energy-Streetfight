class Problem < ActiveRecord::Base
    belongs_to :game
    has_one :resource #the resource that resolves this problem
end
