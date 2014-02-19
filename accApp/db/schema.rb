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

ActiveRecord::Schema.define(version: 20140217160630) do

  create_table "apikeys", force: true do |t|
    t.string   "auth_token", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "applications", force: true do |t|
    t.string   "email",           null: false
    t.string   "password_digest", null: false
    t.integer  "apikey_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "licences", force: true do |t|
    t.string   "licence_type", limit: 20, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resource_types", force: true do |t|
    t.string   "typeName",   limit: 40, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "resources", force: true do |t|
    t.integer  "resource_type_id"
    t.integer  "licence_id"
    t.integer  "tag_id"
    t.integer  "user_id"
    t.string   "name",             limit: 40,  null: false
    t.string   "description",                  null: false
    t.string   "url",              limit: 150, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "resources", ["resource_type_id"], name: "index_resources_on_resource_type_id"

  create_table "resources_tags", id: false, force: true do |t|
    t.integer "resource_id"
    t.integer "tag_id"
  end

  add_index "resources_tags", ["resource_id", "tag_id"], name: "index_resources_tags_on_resource_id_and_tag_id"

  create_table "tags", force: true do |t|
    t.string   "tag",        limit: 20, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "first_name",      limit: 20,              null: false
    t.string   "last_name",       limit: 40,              null: false
    t.string   "email",                      default: "", null: false
    t.string   "password_digest",                         null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
