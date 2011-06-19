class RemoveResourceType < ActiveRecord::Migration
    def self.up
	drop_table :resource_types

	remove_column :resources, :resource_type_id
	remove_column :resources, :ship_id
	remove_column :resources, :island_id

	add_column :islands, :resource_id, :integer
	add_column :ships, :resource_id, :integer
    end

    def self.down
	create_table :resource_types do |t|
	    t.string :name
	    t.text :description
	    t.references :problem_type

	    t.timestamps
	end

	remove_column :islands, :resource_id 
	remove_column :ships, :resource_id

	add_column :resources, :resource_type_id, :integer
	add_column :resources, :ship_id, :integer
	add_column :resources, :island_id, :integer

    end
end
