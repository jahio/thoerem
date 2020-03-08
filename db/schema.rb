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

ActiveRecord::Schema.define(version: 2020_03_07_061441) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "devices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "serial_no"
    t.string "firmware_version"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "notifications", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "msg"
    t.boolean "dismissed"
    t.uuid "device_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["device_id"], name: "index_notifications_on_device_id"
    t.index ["dismissed"], name: "index_notifications_on_dismissed"
  end

  create_table "telemetries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "device_id", null: false
    t.float "temp_c", default: 0.0, null: false
    t.float "humidity_percentage", default: 0.0, null: false
    t.float "carbon_monoxide", default: 0.0, null: false
    t.string "health"
    t.datetime "recorded_at", default: "2020-03-08 11:03:38", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["carbon_monoxide"], name: "index_telemetries_on_carbon_monoxide"
    t.index ["device_id"], name: "index_telemetries_on_device_id"
    t.index ["health"], name: "index_telemetries_on_health"
    t.index ["recorded_at"], name: "index_telemetries_on_recorded_at"
  end

end
