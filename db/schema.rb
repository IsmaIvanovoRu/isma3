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

ActiveRecord::Schema.define(version: 20131213085247) do

  create_table "academic_titles", force: true do |t|
    t.string   "name",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "article_types", force: true do |t|
    t.string   "name",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "articles", force: true do |t|
    t.integer  "user_id"
    t.string   "title",           default: "",    null: false
    t.text     "content"
    t.date     "exp_date"
    t.boolean  "published",       default: false
    t.boolean  "fixed",           default: false
    t.boolean  "commentable",     default: false
    t.integer  "division_id"
    t.integer  "group_id"
    t.integer  "article_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "articles", ["article_type_id"], name: "index_articles_on_article_type_id", using: :btree
  add_index "articles", ["division_id"], name: "index_articles_on_division_id", using: :btree
  add_index "articles", ["group_id"], name: "index_articles_on_group_id", using: :btree
  add_index "articles", ["user_id"], name: "index_articles_on_user_id", using: :btree

  create_table "articles_attachments", id: false, force: true do |t|
    t.integer "article_id",    null: false
    t.integer "attachment_id", null: false
  end

  create_table "attachments", force: true do |t|
    t.integer  "article_id"
    t.string   "title",      default: "", null: false
    t.string   "mime_type",  default: "", null: false
    t.binary   "data"
    t.binary   "thumbnail"
    t.text     "content"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "attachments", ["article_id"], name: "index_attachments_on_article_id", using: :btree

  create_table "attachments_profiles", id: false, force: true do |t|
    t.integer "profile_id",    null: false
    t.integer "attachment_id", null: false
  end

  create_table "degrees", force: true do |t|
    t.string   "name",       default: "", null: false
    t.string   "short_name", default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "details", force: true do |t|
    t.string   "key",        default: "", null: false
    t.string   "value",      default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "division_types", force: true do |t|
    t.string   "name",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "divisions", force: true do |t|
    t.string   "name",             default: "",  null: false
    t.integer  "division_type_id"
    t.string   "address",          default: ""
    t.float    "latitude",         default: 0.0
    t.float    "longitude",        default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "divisions", ["division_type_id"], name: "index_divisions_on_division_type_id", using: :btree

  create_table "groups", force: true do |t|
    t.integer  "parent_id"
    t.string   "name",          default: "",    null: false
    t.boolean  "administrator", default: false, null: false
    t.boolean  "moderator",     default: false, null: false
    t.boolean  "writer",        default: false, null: false
    t.boolean  "reader",        default: false, null: false
    t.boolean  "commentator",   default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["parent_id"], name: "index_groups_on_parent_id", using: :btree

  create_table "groups_users", id: false, force: true do |t|
    t.integer "user_id",  null: false
    t.integer "group_id", null: false
  end

  create_table "menus", force: true do |t|
    t.string   "location",   default: "",    null: false
    t.string   "title",      default: "",    null: false
    t.string   "path",       default: "",    null: false
    t.integer  "weigth",     default: 0,     null: false
    t.boolean  "private",    default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "menus", ["path"], name: "index_menus_on_path", using: :btree
  add_index "menus", ["title"], name: "index_menus_on_title", using: :btree

  create_table "post_types", force: true do |t|
    t.string   "name",       default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: true do |t|
    t.integer  "user_id"
    t.integer  "division_id"
    t.integer  "parent_id"
    t.integer  "post_type_id"
    t.string   "name",         default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "posts", ["division_id"], name: "index_posts_on_division_id", using: :btree
  add_index "posts", ["parent_id"], name: "index_posts_on_parent_id", using: :btree
  add_index "posts", ["post_type_id"], name: "index_posts_on_post_type_id", using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "profiles", force: true do |t|
    t.integer  "user_id"
    t.string   "first_name",        default: "", null: false
    t.string   "middle_name",       default: ""
    t.string   "last_name",         default: "", null: false
    t.integer  "degree_id"
    t.integer  "academic_title_id"
    t.string   "phone",             default: ""
    t.text     "about"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "profiles", ["academic_title_id"], name: "index_profiles_on_academic_title_id", using: :btree
  add_index "profiles", ["degree_id"], name: "index_profiles_on_degree_id", using: :btree
  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
