class MeterReading < ActiveRecord::Base
    attr_accessible [:reading]
    belongs_to :user
end
