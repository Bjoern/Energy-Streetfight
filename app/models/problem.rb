class Problem < ActiveRecord::Base
  belongs_to :problem_type
  belongs_to :island
end
