class Vote < ActiveRecord::Base
  belongs_to :ship
  belongs_to :user
  belongs_to :destination
  belongs_to :resource
end
