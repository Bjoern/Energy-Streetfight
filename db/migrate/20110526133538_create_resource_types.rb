class CreateResourceTypes < ActiveRecord::Migration
  def self.up
    create_table :resource_types do |t|
      t.string :name
      t.text :description
      t.references :problem_type

      t.timestamps
    end
  end

  def self.down
    drop_table :resource_types
  end
end
