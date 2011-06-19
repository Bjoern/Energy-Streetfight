class MeterReading < ActiveRecord::Base
    attr_Accessible [:reading]
    belongs_to :user
end
