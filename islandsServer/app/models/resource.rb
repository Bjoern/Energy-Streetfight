class Resource < ActiveRecord::Base
  belongs_to :problem
  belongs_to :island
  belongs_to :ship
  belongs_to :resource_type
end
