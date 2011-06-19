class Vote < ActiveRecord::Base
    attr_accessible [:destination_id, :action, :resource_id]

    belongs_to :ship
    belongs_to :user
    belongs_to :destination
    belongs_to :resource
end
