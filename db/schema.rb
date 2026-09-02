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

ActiveRecord::Schema[8.1].define(version: 2026_09_02_181345) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "call_logs", force: :cascade do |t|
    t.integer "callee_id"
    t.integer "caller_id"
    t.datetime "created_at", null: false
    t.integer "duration"
    t.datetime "ended_at"
    t.integer "room_id"
    t.datetime "started_at"
    t.string "status"
    t.datetime "updated_at", null: false
  end

  create_table "calls", force: :cascade do |t|
    t.bigint "callee_id", null: false
    t.string "callee_type", null: false
    t.bigint "caller_id", null: false
    t.string "caller_type", null: false
    t.datetime "created_at", null: false
    t.integer "duration"
    t.datetime "ended_at"
    t.datetime "started_at"
    t.string "status", default: "pending"
    t.datetime "updated_at", null: false
    t.index ["callee_type", "callee_id"], name: "index_calls_on_callee"
    t.index ["caller_type", "caller_id"], name: "index_calls_on_caller"
  end

  create_table "devices", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "ip_address"
    t.datetime "last_seen_at"
    t.string "name"
    t.string "sip_address"
    t.string "status"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_devices_on_user_id"
  end

  create_table "rooms", force: :cascade do |t|
    t.boolean "active"
    t.datetime "created_at", null: false
    t.integer "max_participants"
    t.string "name"
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["user_id"], name: "index_rooms_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.string "password_digest"
    t.string "role"
    t.string "status"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "devices", "users"
  add_foreign_key "rooms", "users"
end
