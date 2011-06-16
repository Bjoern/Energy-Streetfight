# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110616182747) do

  create_table "games", :force => true do |t|
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "islands", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "x"
    t.integer  "y"
    t.integer  "diameter"
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "meter_readings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "turn"
    t.integer  "reading"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "problem_types", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "game_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "problems", :force => true do |t|
    t.integer  "problem_type_id"
    t.integer  "island_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resource_types", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "problem_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resources", :force => true do |t|
    t.integer  "problem_id"
    t.integer  "island_id"
    t.integer  "ship_id"
    t.integer  "resource_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ships", :force => true do |t|
    t.string   "house_number"
    t.integer  "game_id"
    t.integer  "destination_id"
    t.float    "speed"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "x"
    t.integer  "y"
    t.string   "name"
  end

  create_table "users", :force => true do |t|
    t.integer  "ship_id"
    t.string   "password"
    t.string   "salt"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  create_table "votes", :force => true do |t|
    t.integer  "turn"
    t.integer  "user_id"
    t.integer  "destination_id"
    t.string   "action"
    t.integer  "resource_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
