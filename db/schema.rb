# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2026_03_17_143111) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "enrollments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "game_post_id", null: false
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["game_post_id"], name: "index_enrollments_on_game_post_id"
    t.index ["user_id"], name: "index_enrollments_on_user_id"
  end

  create_table "entries", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
  end

  create_table "game_posts", force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.datetime "time_start"
    t.datetime "time_end"
    t.bigint "user_owner_id", null: false
    t.string "image"
    t.integer "num_needed"
    t.integer "total_players"
    t.text "description"
    t.text "details"
    t.datetime "cutoff_time"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_owner_id"], name: "index_game_posts_on_user_owner_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "username"
    t.string "password_digest"
    t.string "photo"
    t.text "bio"
    t.integer "games_joined_count", default: 0
    t.integer "total_accepted_count", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "enrollments", "game_posts"
  add_foreign_key "enrollments", "users"
  add_foreign_key "game_posts", "users", column: "user_owner_id"
end
