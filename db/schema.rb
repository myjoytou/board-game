# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20161012150859) do

  create_table "boards", force: :cascade do |t|
    t.integer "game_id", limit: 4
    t.string  "x_dime",  limit: 255
    t.string  "y_dime",  limit: 255
  end

  add_index "boards", ["game_id"], name: "index_boards_on_game_id", using: :btree

  create_table "cells", force: :cascade do |t|
    t.integer "board_id", limit: 4
    t.string  "cell_no",  limit: 255
    t.string  "color",    limit: 255
    t.boolean "occupied", limit: 1,   default: false
  end

  add_index "cells", ["board_id"], name: "index_cells_on_board_id", using: :btree
  add_index "cells", ["cell_no"], name: "index_cells_on_cell_no", using: :btree

  create_table "games", force: :cascade do |t|
    t.string "name",         limit: 255
    t.string "channel_name", limit: 255
    t.string "dimension_x",  limit: 255
    t.string "dimension_y",  limit: 255
    t.string "status",       limit: 255, default: "inactive"
    t.string "winner",       limit: 255
    t.string "block_time",   limit: 255, default: "5"
  end

  add_index "games", ["channel_name"], name: "index_games_on_channel_name", using: :btree
  add_index "games", ["name"], name: "index_games_on_name", using: :btree

  create_table "players", force: :cascade do |t|
    t.integer "game_id", limit: 4
    t.string  "name",    limit: 255
    t.string  "color",   limit: 255
  end

  add_index "players", ["game_id"], name: "index_players_on_game_id", using: :btree
  add_index "players", ["name"], name: "index_players_on_name", using: :btree

end
