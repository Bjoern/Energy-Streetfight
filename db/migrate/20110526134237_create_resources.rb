class CreateResources < ActiveRecord::Migration
  def self.up
    create_table :resources do |t|
      t.references :problem
      t.references :island
      t.references :ship
      t.references :resource_type
    end
  end

  def self.down
    drop_table :resources
  end
end
