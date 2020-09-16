# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_09_13_010443) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "eb_attendees", force: :cascade do |t|
    t.string "user_eventbrite_id"
    t.string "email"
    t.boolean "used"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "event_id"
  end

  create_table "events", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "description"
    t.integer "price"
    t.integer "host_user"
    t.datetime "start_time"
    t.datetime "finish_time"
    t.string "timezone"
    t.string "venue"
    t.string "venueData"
    t.string "eventbrite_id"
    t.string "eventbrite_webhook_id"
    t.integer "max_attendees", default: 50, null: false
    t.integer "event_length", default: 120, null: false
    t.integer "amount_paid", default: 0, null: false
    t.string "admin_venue_data", default: "{}", null: false
    t.string "static_venue_data", default: "{}", null: false
  end

  create_table "livestreams", force: :cascade do |t|
    t.string "mux_id", null: false
    t.datetime "last_update", null: false
    t.string "data", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["mux_id"], name: "index_livestreams_on_mux_id", unique: true
  end

  create_table "user_events", force: :cascade do |t|
    t.integer "user_id"
    t.integer "event_id"
    t.string "role", default: "Attendee", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.string "uid"
    t.string "auth_provider"
    t.string "auth_token"
    t.string "twitter_handle"
    t.string "github_username"
    t.string "company"
    t.string "bio"
    t.string "image_url"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "eventbrite_token"
    t.string "eventbrite_user_id"
  end

end
