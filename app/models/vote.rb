class Vote < ActiveRecord::Base
    attr_accessible :destination_id, :unload, :load

    belongs_to :ship
    belongs_to :user
end
