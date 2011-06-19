class LinkResourceToProblemType < ActiveRecord::Migration
  def self.up
      rename_column :resources, :problem_id, :problem_type_id
  end

  def self.down
      rename_column :resources, :problem_type_id, :problem_id
  end
end
