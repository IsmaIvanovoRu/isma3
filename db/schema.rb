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

ActiveRecord::Schema.define(version: 20160111101918) do

  create_table "academic_titles", force: :cascade do |t|
    t.string   "name",       limit: 255, default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "article_types", force: :cascade do |t|
    t.string   "name",       limit: 255, default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "articles", force: :cascade do |t|
    t.integer  "user_id",         limit: 4
    t.string   "title",           limit: 255,      default: "",    null: false
    t.text     "content",         limit: 16777215
    t.date     "exp_date"
    t.boolean  "published",                        default: false
    t.boolean  "fixed",                            default: false
    t.boolean  "commentable",                      default: false
    t.integer  "division_id",     limit: 4
    t.integer  "group_id",        limit: 4
    t.integer  "article_type_id", limit: 4
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "message",         limit: 255,      default: ""
    t.boolean  "skip_frontend",                    default: false
  end

  add_index "articles", ["article_type_id"], name: "index_articles_on_article_type_id", using: :btree
  add_index "articles", ["division_id"], name: "index_articles_on_division_id", using: :btree
  add_index "articles", ["group_id"], name: "index_articles_on_group_id", using: :btree
  add_index "articles", ["user_id"], name: "index_articles_on_user_id", using: :btree

  create_table "articles_attachments", id: false, force: :cascade do |t|
    t.integer "article_id",    limit: 4, null: false
    t.integer "attachment_id", limit: 4, null: false
  end

  create_table "attachments", force: :cascade do |t|
    t.integer  "article_id", limit: 4
    t.string   "title",      limit: 255,      default: "", null: false
    t.string   "mime_type",  limit: 255,      default: "", null: false
    t.binary   "data",       limit: 16777215
    t.binary   "thumbnail",  limit: 16777215
    t.text     "content",    limit: 16777215
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "score",      limit: 4,        default: 0
  end

  add_index "attachments", ["article_id"], name: "index_attachments_on_article_id", using: :btree

  create_table "attachments_divisions", id: false, force: :cascade do |t|
    t.integer "division_id",   limit: 4, null: false
    t.integer "attachment_id", limit: 4, null: false
  end

  create_table "attachments_profiles", id: false, force: :cascade do |t|
    t.integer "profile_id",    limit: 4, null: false
    t.integer "attachment_id", limit: 4, null: false
  end

  create_table "comments", force: :cascade do |t|
    t.integer  "article_id", limit: 4
    t.integer  "user_id",    limit: 4
    t.text     "content",    limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "published",                default: false, null: false
  end

  add_index "comments", ["article_id"], name: "index_comments_on_article_id", using: :btree
  add_index "comments", ["user_id"], name: "index_comments_on_user_id", using: :btree

  create_table "degrees", force: :cascade do |t|
    t.string   "name",       limit: 255, default: "", null: false
    t.string   "short_name", limit: 255, default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "details", force: :cascade do |t|
    t.string   "key",        limit: 255,   default: "", null: false
    t.text     "value",      limit: 65535,              null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "tag_type",   limit: 255
    t.boolean  "block"
    t.string   "tag_name",   limit: 255
  end

  create_table "division_types", force: :cascade do |t|
    t.string   "name",       limit: 255, default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "divisions", force: :cascade do |t|
    t.string   "name",             limit: 255,   default: "",   null: false
    t.integer  "division_type_id", limit: 4
    t.string   "address",          limit: 255,   default: ""
    t.float    "latitude",         limit: 24,    default: 0.0
    t.float    "longitude",        limit: 24,    default: 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",            limit: 255,   default: ""
    t.text     "about",            limit: 65535
    t.string   "url",              limit: 255,   default: ""
    t.integer  "reference",        limit: 4
    t.boolean  "in_structure",                   default: true
  end

  add_index "divisions", ["division_type_id"], name: "index_divisions_on_division_type_id", using: :btree

  create_table "feedbacks", force: :cascade do |t|
    t.integer  "to",         limit: 4,                     null: false
    t.integer  "from",       limit: 4,                     null: false
    t.text     "question",   limit: 65535
    t.text     "answer",     limit: 65535
    t.boolean  "public",                   default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: :cascade do |t|
    t.integer  "parent_id",     limit: 4
    t.string   "name",          limit: 255, default: "",    null: false
    t.boolean  "administrator",             default: false, null: false
    t.boolean  "moderator",                 default: false, null: false
    t.boolean  "writer",                    default: false, null: false
    t.boolean  "reader",                    default: false, null: false
    t.boolean  "commentator",               default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["parent_id"], name: "index_groups_on_parent_id", using: :btree

  create_table "groups_users", id: false, force: :cascade do |t|
    t.integer "user_id",  limit: 4, null: false
    t.integer "group_id", limit: 4, null: false
  end

  create_table "menus", force: :cascade do |t|
    t.string   "location",   limit: 255, default: "",    null: false
    t.string   "title",      limit: 255, default: "",    null: false
    t.string   "path",       limit: 255, default: "",    null: false
    t.integer  "weigth",     limit: 4,   default: 0,     null: false
    t.boolean  "private",                default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "parent_id",  limit: 4
  end

  add_index "menus", ["parent_id"], name: "index_menus_on_parent_id", using: :btree
  add_index "menus", ["path"], name: "index_menus_on_path", using: :btree
  add_index "menus", ["title"], name: "index_menus_on_title", using: :btree

  create_table "post_types", force: :cascade do |t|
    t.string   "name",       limit: 255, default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "posts", force: :cascade do |t|
    t.integer  "user_id",      limit: 4
    t.integer  "division_id",  limit: 4
    t.integer  "parent_id",    limit: 4
    t.integer  "post_type_id", limit: 4
    t.string   "name",         limit: 255, default: "",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "phone",        limit: 255, default: ""
    t.boolean  "feedback",                 default: false, null: false
  end

  add_index "posts", ["division_id"], name: "index_posts_on_division_id", using: :btree
  add_index "posts", ["parent_id"], name: "index_posts_on_parent_id", using: :btree
  add_index "posts", ["post_type_id"], name: "index_posts_on_post_type_id", using: :btree
  add_index "posts", ["user_id"], name: "index_posts_on_user_id", using: :btree

  create_table "profiles", force: :cascade do |t|
    t.integer  "user_id",            limit: 4
    t.string   "first_name",         limit: 255,   default: "", null: false
    t.string   "middle_name",        limit: 255,   default: ""
    t.string   "last_name",          limit: 255,   default: "", null: false
    t.integer  "degree_id",          limit: 4
    t.integer  "academic_title_id",  limit: 4
    t.string   "phone",              limit: 255,   default: ""
    t.text     "about",              limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",              limit: 255,   default: ""
    t.string   "discipline",         limit: 255,   default: ""
    t.string   "qualification",      limit: 255,   default: ""
    t.text     "development",        limit: 65535
    t.integer  "general_experience", limit: 4,     default: 0
    t.integer  "special_experience", limit: 4,     default: 0
  end

  add_index "profiles", ["academic_title_id"], name: "index_profiles_on_academic_title_id", using: :btree
  add_index "profiles", ["degree_id"], name: "index_profiles_on_degree_id", using: :btree
  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "encrypted_password",     limit: 255, default: "", null: false
    t.string   "reset_password_token",   limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          limit: 4,   default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip",     limit: 255
    t.string   "last_sign_in_ip",        limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "login",                  limit: 255, default: "", null: false
  end

  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
