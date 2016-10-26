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

ActiveRecord::Schema.define(version: 20161026091502) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_sampler_endpoints", force: :cascade do |t|
    t.text     "path",           null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.text     "request_method", null: false
    t.index ["path"], name: "index_api_sampler_endpoints_on_path", using: :btree
    t.index ["request_method", "path"], name: "index_api_sampler_endpoints_on_request_method_and_path", unique: true, using: :btree
  end

  create_table "api_sampler_samples", force: :cascade do |t|
    t.integer  "endpoint_id",   null: false
    t.text     "query",         null: false
    t.text     "request_body",  null: false
    t.text     "response_body", null: false
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["endpoint_id"], name: "index_api_sampler_samples_on_endpoint_id", using: :btree
  end

  create_table "api_sampler_samples_tags", id: false, force: :cascade do |t|
    t.integer "sample_id", null: false
    t.integer "tag_id",    null: false
    t.index ["sample_id", "tag_id"], name: "index_api_sampler_samples_tags_on_sample_id_and_tag_id", unique: true, using: :btree
    t.index ["sample_id"], name: "index_api_sampler_samples_tags_on_sample_id", using: :btree
    t.index ["tag_id"], name: "index_api_sampler_samples_tags_on_tag_id", using: :btree
  end

  create_table "api_sampler_tags", force: :cascade do |t|
    t.text     "name",       null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_api_sampler_tags_on_name", unique: true, using: :btree
  end

  add_foreign_key "api_sampler_samples", "api_sampler_endpoints", column: "endpoint_id"
  add_foreign_key "api_sampler_samples_tags", "api_sampler_samples", column: "sample_id", on_delete: :cascade
  add_foreign_key "api_sampler_samples_tags", "api_sampler_tags", column: "tag_id"
end
