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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130226135107) do

  create_table "emails", :force => true do |t|
    t.string   "address"
    t.datetime "confirmation_sent_at"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.boolean  "main_address"
    t.integer  "user_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  add_index "emails", ["address"], :name => "index_emails_on_address", :unique => true
  add_index "emails", ["confirmation_token"], :name => "index_emails_on_confirmation_token", :unique => true
  add_index "emails", ["user_id", "main_address"], :name => "index_emails_on_user_id_and_main_address", :unique => true
  add_index "emails", ["user_id"], :name => "index_emails_on_user_id"

  create_table "hubs", :force => true do |t|
    t.string   "name"
    t.string   "host"
    t.string   "code"
    t.string   "language"
    t.integer  "main_hub_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "hubs", ["code"], :name => "index_hubs_on_code", :unique => true
  add_index "hubs", ["host"], :name => "index_hubs_on_host", :unique => true

  create_table "rounds", :force => true do |t|
    t.datetime "start_date"
    t.datetime "end_date"
    t.string   "version"
    t.integer  "server_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "rounds", ["server_id"], :name => "index_rounds_on_server_id"

  create_table "servers", :force => true do |t|
    t.string   "name"
    t.string   "code"
    t.string   "host"
    t.integer  "hub_id"
    t.integer  "speed"
    t.string   "world_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "servers", ["host"], :name => "index_servers_on_host", :unique => true

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "username"
    t.string   "password_hash"
    t.string   "password_salt"
    t.string   "reset_password_token"
    t.datetime "reset_token_sent_at"
    t.integer  "sign_in_count",        :default => 0
    t.datetime "last_sign_in_at"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "users", ["password_hash"], :name => "index_users_on_password_hash"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end
