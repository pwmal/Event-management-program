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

ActiveRecord::Schema[7.2].define(version: 2025_04_16_015057) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "bookings", force: :cascade do |t|
    t.datetime "reserved_at"
    t.datetime "expires_at"
    t.string "status"
    t.bigint "ticket_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ticket_id"], name: "index_bookings_on_ticket_id"
  end

  create_table "purchases", force: :cascade do |t|
    t.datetime "purchase_date"
    t.bigint "ticket_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ticket_id"], name: "index_purchases_on_ticket_id"
    t.index ["user_id"], name: "index_purchases_on_user_id"
  end

  create_table "ticket_blocks", force: :cascade do |t|
    t.bigint "ticket_id", null: false
    t.datetime "blocked_at"
    t.string "reason"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ticket_id"], name: "index_ticket_blocks_on_ticket_id"
  end

  create_table "ticket_categories", force: :cascade do |t|
    t.string "name"
    t.float "base_price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tickets", force: :cascade do |t|
    t.datetime "event_date"
    t.float "current_price"
    t.string "status"
    t.bigint "ticket_category_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ticket_category_id"], name: "index_tickets_on_ticket_category_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "document_number"
    t.string "document_type"
    t.string "full_name"
    t.datetime "date_of_birth"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email"
  end

  add_foreign_key "bookings", "tickets"
  add_foreign_key "purchases", "tickets"
  add_foreign_key "purchases", "users"
  add_foreign_key "ticket_blocks", "tickets"
  add_foreign_key "tickets", "ticket_categories"
end
