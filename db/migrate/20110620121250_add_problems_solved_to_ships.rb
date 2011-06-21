class AddProblemsSolvedToShips < ActiveRecord::Migration
  def self.up
      add_column :ships, :problems_solved, :integer, :default => 0
  end

  def self.down
      remove_column :ships, :problems_solved
  end
end
