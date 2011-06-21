class CreateProblems < ActiveRecord::Migration
  def self.up
    create_table :problems do |t|
      t.references :problem_type
      t.references :island
    end
  end

  def self.down
    drop_table :problems
  end
end
