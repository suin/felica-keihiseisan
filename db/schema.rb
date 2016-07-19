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

ActiveRecord::Schema.define(version: 20160715074018) do

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace",     limit: 255
    t.text     "body",          limit: 65535
    t.string   "resource_id",   limit: 255,   null: false
    t.string   "resource_type", limit: 255,   null: false
    t.integer  "author_id",     limit: 4
    t.string   "author_type",   limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "active_admin_comments", ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
  add_index "active_admin_comments", ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
  add_index "active_admin_comments", ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  limit: 255, default: "", null: false
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "name",                   limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "admin_users", ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
  add_index "admin_users", ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree

  create_table "card_readers", force: :cascade do |t|
    t.string   "name",       limit: 255, null: false
    t.string   "token",      limit: 255, null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "card_readers", ["token"], name: "index_card_readers_on_token", unique: true, using: :btree

  create_table "cards", force: :cascade do |t|
    t.integer  "user_id",     limit: 4
    t.string   "idm",         limit: 16,               null: false
    t.string   "name",        limit: 255, default: "", null: false
    t.string   "system_code", limit: 255,              null: false
    t.string   "system",      limit: 255,              null: false
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
  end

  add_index "cards", ["idm"], name: "index_cards_on_idm", unique: true, using: :btree
  add_index "cards", ["user_id"], name: "fk_rails_8ef7749967", using: :btree

  create_table "suica_histories", force: :cascade do |t|
    t.integer  "card_id",              limit: 4,                  null: false
    t.integer  "serial_number",        limit: 4,                  null: false
    t.string   "data_type",            limit: 255,                null: false
    t.integer  "terminal_code",        limit: 4,                  null: false
    t.integer  "processing_code",      limit: 4,                  null: false
    t.date     "date",                                            null: false
    t.integer  "balance",              limit: 4,                  null: false
    t.integer  "entered_line_code",    limit: 4
    t.integer  "entered_station_code", limit: 4
    t.integer  "exited_line_code",     limit: 4
    t.integer  "exited_station_code",  limit: 4
    t.integer  "region",               limit: 4
    t.boolean  "is_expense",                       default: true, null: false
    t.string   "block",                limit: 32,                 null: false
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "suica_histories", ["card_id", "serial_number", "date"], name: "index_suica_histories_on_card_id_and_serial_number_and_date", unique: true, using: :btree

  create_table "suica_processings", force: :cascade do |t|
    t.integer "code", limit: 4,   null: false
    t.string  "name", limit: 255, null: false
  end

  add_index "suica_processings", ["code"], name: "index_suica_processings_on_code", unique: true, using: :btree

  create_table "suica_stations", force: :cascade do |t|
    t.integer "area_code",    limit: 4,   null: false
    t.integer "line_code",    limit: 4,   null: false
    t.integer "station_code", limit: 4,   null: false
    t.string  "company",      limit: 255, null: false
    t.string  "line",         limit: 255, null: false
    t.string  "station",      limit: 255, null: false
    t.string  "note",         limit: 255, null: false
  end

  add_index "suica_stations", ["area_code", "line_code", "station_code"], name: "index_suica_stations_on_area_code_and_line_code_and_station_code", unique: true, using: :btree

  create_table "suica_terminals", force: :cascade do |t|
    t.integer "code", limit: 4,   null: false
    t.string  "name", limit: 255, null: false
  end

  add_index "suica_terminals", ["code"], name: "index_suica_terminals_on_code", unique: true, using: :btree

  add_foreign_key "cards", "admin_users", column: "user_id"
  add_foreign_key "suica_histories", "cards", on_update: :cascade, on_delete: :cascade
end
