class Problem < ActiveRecord::Base
  belongs_to :problemType
  belongs_to :island
end
