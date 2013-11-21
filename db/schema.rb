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

ActiveRecord::Schema.define(version: 20130410163128) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_keys", force: true do |t|
    t.integer  "travian_account_id"
    t.string   "key"
    t.integer  "valid_for"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hubs", force: true do |t|
    t.string   "name"
    t.string   "host"
    t.string   "code"
    t.string   "language"
    t.integer  "main_hub_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hubs", ["code"], name: "index_hubs_on_code", unique: true, using: :btree
  add_index "hubs", ["host"], name: "index_hubs_on_host", unique: true, using: :btree

  create_table "pre_subscriptions", force: true do |t|
    t.string   "email"
    t.string   "name"
    t.integer  "hub_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pre_subscriptions", ["email"], name: "index_pre_subscriptions_on_email", unique: true, using: :btree
  add_index "pre_subscriptions", ["hub_id"], name: "index_pre_subscriptions_on_hub_id", using: :btree

  create_table "rounds", force: true do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "version"
    t.integer  "server_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rounds", ["server_id"], name: "index_rounds_on_server_id", using: :btree

  create_table "servers", force: true do |t|
    t.string   "name"
    t.string   "code"
    t.string   "host"
    t.integer  "hub_id"
    t.integer  "speed"
    t.string   "world_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "servers", ["host"], name: "index_servers_on_host", unique: true, using: :btree

  create_table "travian_accounts", force: true do |t|
    t.integer  "round_id"
    t.integer  "user_id"
    t.integer  "uid"
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "travian_accounts", ["round_id"], name: "index_travian_accounts_on_round_id", using: :btree
  add_index "travian_accounts", ["user_id"], name: "index_travian_accounts_on_user_id", using: :btree
  add_index "travian_accounts", ["username", "round_id"], name: "index_travian_accounts_on_username_and_round_id", unique: true, using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email",                                        null: false
    t.string   "username"
    t.string   "password_hash",        limit: 128,             null: false
    t.string   "password_salt",        limit: 128,             null: false
    t.datetime "confirmation_sent_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.string   "reset_password_token"
    t.datetime "reset_token_sent_at"
    t.integer  "sign_in_count",                    default: 0
    t.datetime "last_sign_in_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "client_key"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["password_hash"], name: "index_users_on_password_hash", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["username"], name: "index_users_on_username", unique: true, using: :btree

end
