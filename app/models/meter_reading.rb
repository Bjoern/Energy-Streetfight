class MeterReading < ActiveRecord::Base
    validates_presence_of :reading

    attr_accessible :reading
    belongs_to :user
end
