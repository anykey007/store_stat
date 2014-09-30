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

ActiveRecord::Schema.define(version: 20140929140246) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "documents", force: true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.integer  "store_id"
  end

  add_index "documents", ["store_id"], name: "index_documents_on_store_id", using: :btree

  create_table "rows", force: true do |t|
    t.datetime "visit_data"
    t.string   "mac_address"
    t.integer  "a"
    t.integer  "b"
    t.integer  "c"
    t.integer  "d"
    t.integer  "e"
    t.integer  "f"
    t.integer  "g"
    t.integer  "h"
    t.integer  "document_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rows", ["document_id"], name: "index_rows_on_document_id", using: :btree

  create_table "statistics", force: true do |t|
    t.integer  "store_id"
    t.datetime "period_start"
    t.datetime "period_end"
    t.float    "avg_dwell_time",           default: 0.0
    t.integer  "unique_visitors_count",    default: 0
    t.integer  "repeating_visitors_count", default: 0
    t.string   "period_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "statistics", ["store_id"], name: "index_statistics_on_store_id", using: :btree

  create_table "stores", force: true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
