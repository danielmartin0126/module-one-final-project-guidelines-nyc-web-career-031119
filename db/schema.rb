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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20190326174236) do

  create_table "captured_pokemons", force: :cascade do |t|
    t.integer "trainer_id"
    t.integer "pokemon_id"
  end

  create_table "pokemons", force: :cascade do |t|
    t.string   "name"
    t.string   "genus"
    t.string   "primary_type"
    t.string   "secondary_type"
    t.string   "flavor_text"
    t.integer  "level"
    t.integer  "speed"
    t.integer  "special_attack"
    t.integer  "special_defense"
    t.integer  "attack"
    t.integer  "defense"
    t.integer  "hp"
    t.integer  "capture_rate"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.integer  "pokeid"
  end

  create_table "trainers", force: :cascade do |t|
    t.string "name"
    t.string "favourite_pokemon"
  end

end
