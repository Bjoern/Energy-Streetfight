class RemoveProblemTypeAndMoveProblemReferenceToIsland < ActiveRecord::Migration
    def self.up
	remove_column :resources, :problem_type_id

	drop_table :problem_types

	remove_column :problems, :island_id
	remove_column :problems, :problem_type_id

	add_column :problems, :game_id, :integer
	add_column :problems, :resource_id, :integer
	add_column :problems, :name, :string

	add_column :islands, :problem_id, :integer
    end

    def self.down
	create_table "problem_types", :force => true do |t|
	    t.string   "name"
	    t.text     "description"
	    t.integer  "game_id"
	    t.datetime "created_at"
	    t.datetime "updated_at"
	end

	add_column :resources, :problem_type_id, :integer
	add_column :problems, :island_id, :integer
	add_column :problems, :problem_type_id, :integer

	remove_column :problems, :game_id, :integer
	remove_column :problems, :resource_id, :integer
	remove_column :problems, :name, :string

	remove_column :islands, :problem_id, :integer
    end
end
