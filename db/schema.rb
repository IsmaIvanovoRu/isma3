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

ActiveRecord::Schema.define(version: 20210329120527) do

  create_table "academic_plans", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.integer  "attachment_id",          limit: 4
    t.integer  "educational_program_id", limit: 4
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "academic_plans", ["attachment_id"], name: "index_academic_plans_on_attachment_id", using: :btree
  add_index "academic_plans", ["educational_program_id"], name: "index_academic_plans_on_educational_program_id", using: :btree

  create_table "academic_schedules", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.integer  "attachment_id",          limit: 4
    t.integer  "educational_program_id", limit: 4
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "academic_schedules", ["attachment_id"], name: "index_academic_schedules_on_attachment_id", using: :btree
  add_index "academic_schedules", ["educational_program_id"], name: "index_academic_schedules_on_educational_program_id", using: :btree

  create_table "academic_titles", force: :cascade do |t|
    t.string   "name",       limit: 255, default: "", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "accreditations", force: :cascade do |t|
    t.string   "number",          limit: 255
    t.date     "date_of_issue"
    t.date     "expiration_date"
    t.integer  "attachment_id",   limit: 4
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  add_index "accreditations", ["attachment_id"], name: "index_accreditations_on_attachment_id", using: :btree

  create_table "achievement_categories", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.text     "description", limit: 16777215
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "achievement_results", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "achievements", force: :cascade do |t|
    t.integer  "user_id",                 limit: 4
    t.string   "event_name",              limit: 255
    t.integer  "achievement_category_id", limit: 4
    t.integer  "achievement_result_id",   limit: 4
    t.date     "event_date"
    t.text     "comment",                 limit: 16777215
    t.boolean  "published",                                default: false
    t.datetime "created_at",                                               null: false
    t.datetime "updated_at",                                               null: false
  end

  add_index "achievements", ["achievement_category_id"], name: "index_achievements_on_achievement_category_id", using: :btree
  add_index "achievements", ["achievement_result_id"], name: "index_achievements_on_achievement_result_id", using: :btree
  add_index "achievements", ["user_id"], name: "index_achievements_on_user_id", using: :btree

  create_table "achievements_attachments", id: false, force: :cascade do |t|
    t.integer "achievement_id", limit: 4, null: false
    t.integer "attachment_id",  limit: 4, null: false
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
    t.integer  "article_id",     limit: 4
    t.string   "title",          limit: 255,      default: "", null: false
    t.string   "mime_type",      limit: 255,      default: "", null: false
    t.text     "content",        limit: 16777215
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "score",          limit: 4,        default: 0
    t.string   "file_name",      limit: 255
    t.string   "thumbnail_name", limit: 255
    t.integer  "user_id",        limit: 4
  end

  add_index "attachments", ["article_id"], name: "index_attachments_on_article_id", using: :btree
  add_index "attachments", ["user_id"], name: "index_attachments_on_user_id", using: :btree

  create_table "attachments_divisions", id: false, force: :cascade do |t|
    t.integer "division_id",   limit: 4, null: false
    t.integer "attachment_id", limit: 4, null: false
  end

  create_table "attachments_profiles", id: false, force: :cascade do |t|
    t.integer "profile_id",    limit: 4, null: false
    t.integer "attachment_id", limit: 4, null: false
  end

  create_table "classrooms", force: :cascade do |t|
    t.integer  "subject_id",  limit: 4
    t.text     "description", limit: 16777215
    t.text     "location",    limit: 16777215
    t.text     "equipment",   limit: 16777215
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.text     "ovz",         limit: 65535
  end

  add_index "classrooms", ["subject_id"], name: "index_classrooms_on_subject_id", using: :btree

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

  create_table "educational_program_numbers", force: :cascade do |t|
    t.integer  "educational_program_id", limit: 4
    t.integer  "number_federal",         limit: 4, default: 0
    t.integer  "number_regional",        limit: 4, default: 0
    t.integer  "number_local",           limit: 4, default: 0
    t.integer  "number_personal",        limit: 4, default: 0
    t.date     "date"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
    t.integer  "number_foreign",         limit: 4, default: 0
  end

  add_index "educational_program_numbers", ["educational_program_id"], name: "index_educational_program_numbers_on_educational_program_id", using: :btree

  create_table "educational_program_perevods", force: :cascade do |t|
    t.integer  "educational_program_id", limit: 4
    t.integer  "number_out_perevod",     limit: 4, default: 0
    t.integer  "number_to_perevod",      limit: 4, default: 0
    t.integer  "number_res_perevod",     limit: 4, default: 0
    t.integer  "number_exp_perevod",     limit: 4, default: 0
    t.date     "date"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  add_index "educational_program_perevods", ["educational_program_id"], name: "index_educational_program_perevods_on_educational_program_id", using: :btree

  create_table "educational_program_priems", force: :cascade do |t|
    t.integer  "educational_program_id", limit: 4
    t.integer  "number_federal",         limit: 4,  default: 0
    t.integer  "number_regional",        limit: 4,  default: 0
    t.integer  "number_local",           limit: 4,  default: 0
    t.integer  "number_personal",        limit: 4,  default: 0
    t.float    "summa",                  limit: 24, default: 0.0
    t.date     "date"
    t.datetime "created_at",                                      null: false
    t.datetime "updated_at",                                      null: false
  end

  add_index "educational_program_priems", ["educational_program_id"], name: "index_educational_program_priems_on_educational_program_id", using: :btree

  create_table "educational_program_researches", force: :cascade do |t|
    t.integer  "educational_program_id", limit: 4
    t.text     "perechen_nir",           limit: 16777215
    t.text     "base_nir",               limit: 16777215
    t.integer  "npr_nir",                limit: 4,        default: 0
    t.integer  "stud_nir",               limit: 4,        default: 0
    t.integer  "monograf_nir",           limit: 4,        default: 0
    t.integer  "article_nir",            limit: 4,        default: 0
    t.integer  "patent_r_nir",           limit: 4,        default: 0
    t.integer  "patent_z_nir",           limit: 4,        default: 0
    t.integer  "svid_r_nir",             limit: 4,        default: 0
    t.integer  "svid_z_nir",             limit: 4,        default: 0
    t.integer  "finance_nir",            limit: 4,        default: 0
    t.date     "date"
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.text     "result_nir",             limit: 65535
  end

  add_index "educational_program_researches", ["educational_program_id"], name: "educational_program_researches_index", using: :btree

  create_table "educational_program_vacants", force: :cascade do |t|
    t.integer  "educational_program_id", limit: 4
    t.integer  "stage",                  limit: 4, default: 0
    t.integer  "number_federal",         limit: 4, default: 0
    t.integer  "number_regional",        limit: 4, default: 0
    t.integer  "number_local",           limit: 4, default: 0
    t.integer  "number_personal",        limit: 4, default: 0
    t.date     "date"
    t.datetime "created_at",                                   null: false
    t.datetime "updated_at",                                   null: false
  end

  add_index "educational_program_vacants", ["educational_program_id"], name: "index_educational_program_vacants_on_educational_program_id", using: :btree

  create_table "educational_programs", force: :cascade do |t|
    t.string   "name",                    limit: 255
    t.string   "code",                    limit: 255
    t.string   "form",                    limit: 255
    t.string   "duration",                limit: 255
    t.integer  "educational_standart_id", limit: 4
    t.string   "level",                   limit: 255
    t.integer  "accreditation_id",        limit: 4
    t.integer  "attachment_id",           limit: 4
    t.datetime "created_at",                                          null: false
    t.datetime "updated_at",                                          null: false
    t.boolean  "active",                              default: true
    t.string   "language",                limit: 255
    t.boolean  "adaptive",                            default: false
  end

  add_index "educational_programs", ["accreditation_id"], name: "index_educational_programs_on_accreditation_id", using: :btree
  add_index "educational_programs", ["attachment_id"], name: "index_educational_programs_on_attachment_id", using: :btree
  add_index "educational_programs", ["educational_standart_id"], name: "index_educational_programs_on_educational_standart_id", using: :btree

  create_table "educational_standarts", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.string   "level",      limit: 255
    t.string   "url",        limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  create_table "feedbacks", force: :cascade do |t|
    t.integer  "to",         limit: 4,                     null: false
    t.integer  "from",       limit: 4,                     null: false
    t.text     "question",   limit: 65535
    t.text     "answer",     limit: 65535
    t.boolean  "public",                   default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "private",                  default: false
  end

  create_table "financial_activities", force: :cascade do |t|
    t.integer  "year",                  limit: 4
    t.decimal  "federal_volume",                    precision: 16, scale: 2, default: 0.0
    t.decimal  "regional_volume",                   precision: 16, scale: 2, default: 0.0
    t.decimal  "municipal_volume",                  precision: 16, scale: 2, default: 0.0
    t.decimal  "personal_volume",                   precision: 16, scale: 2, default: 0.0
    t.string   "financial_report_link", limit: 255
    t.string   "financial_plan_link",   limit: 255
    t.string   "bus_gov_link",          limit: 255
    t.datetime "created_at",                                                               null: false
    t.datetime "updated_at",                                                               null: false
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

  create_table "international_contracts", force: :cascade do |t|
    t.string   "state_name",   limit: 255
    t.string   "org_name",     limit: 255
    t.string   "dog_name",     limit: 255
    t.string   "dog_number",   limit: 255
    t.date     "dog_date"
    t.date     "dog_date_end"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "marks", force: :cascade do |t|
    t.integer  "user_id",                limit: 4
    t.integer  "educational_program_id", limit: 4
    t.text     "subject",                limit: 65535
    t.integer  "value",                  limit: 4,     default: 0
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
  end

  add_index "marks", ["educational_program_id"], name: "index_marks_on_educational_program_id", using: :btree
  add_index "marks", ["user_id"], name: "index_marks_on_user_id", using: :btree

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

  create_table "methodological_supports", force: :cascade do |t|
    t.integer  "attachment_id",          limit: 4
    t.integer  "educational_program_id", limit: 4
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  add_index "methodological_supports", ["attachment_id"], name: "index_methodological_supports_on_attachment_id", using: :btree
  add_index "methodological_supports", ["educational_program_id"], name: "index_methodological_supports_on_educational_program_id", using: :btree

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

  create_table "posts_subjects", id: false, force: :cascade do |t|
    t.integer "post_id",    limit: 4, null: false
    t.integer "subject_id", limit: 4, null: false
  end

  create_table "practices", force: :cascade do |t|
    t.string   "name",                   limit: 255
    t.integer  "attachment_id",          limit: 4
    t.integer  "educational_program_id", limit: 4
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
  end

  add_index "practices", ["attachment_id"], name: "index_practices_on_attachment_id", using: :btree
  add_index "practices", ["educational_program_id"], name: "index_practices_on_educational_program_id", using: :btree

  create_table "profiles", force: :cascade do |t|
    t.integer  "user_id",                limit: 4
    t.string   "first_name",             limit: 255,   default: "",   null: false
    t.string   "middle_name",            limit: 255,   default: ""
    t.string   "last_name",              limit: 255,   default: "",   null: false
    t.integer  "degree_id",              limit: 4
    t.integer  "academic_title_id",      limit: 4
    t.string   "phone",                  limit: 255,   default: ""
    t.text     "about",                  limit: 65535
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email",                  limit: 255,   default: ""
    t.string   "discipline",             limit: 255,   default: ""
    t.string   "qualification",          limit: 255,   default: ""
    t.text     "development",            limit: 65535
    t.integer  "general_experience",     limit: 4,     default: 0
    t.integer  "special_experience",     limit: 4,     default: 0
    t.boolean  "published",                            default: true
    t.string   "teaching_level",         limit: 255
    t.string   "employee_qualification", limit: 255
  end

  add_index "profiles", ["academic_title_id"], name: "index_profiles_on_academic_title_id", using: :btree
  add_index "profiles", ["degree_id"], name: "index_profiles_on_degree_id", using: :btree
  add_index "profiles", ["user_id"], name: "index_profiles_on_user_id", using: :btree

  create_table "subjects", force: :cascade do |t|
    t.string   "name",                     limit: 255
    t.integer  "annotation_attachment_id", limit: 4
    t.integer  "educational_program_id",   limit: 4
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.integer  "full_text_attachment_id",  limit: 4
  end

  add_index "subjects", ["annotation_attachment_id"], name: "index_subjects_on_annotation_attachment_id", using: :btree
  add_index "subjects", ["educational_program_id"], name: "index_subjects_on_educational_program_id", using: :btree
  add_index "subjects", ["full_text_attachment_id"], name: "index_subjects_on_full_text_attachment_id", using: :btree

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

  add_foreign_key "academic_plans", "attachments"
  add_foreign_key "academic_plans", "educational_programs"
  add_foreign_key "academic_schedules", "attachments"
  add_foreign_key "academic_schedules", "educational_programs"
  add_foreign_key "accreditations", "attachments"
  add_foreign_key "achievements", "achievement_categories"
  add_foreign_key "achievements", "achievement_results"
  add_foreign_key "achievements", "users"
  add_foreign_key "attachments", "users"
  add_foreign_key "classrooms", "subjects"
  add_foreign_key "educational_program_numbers", "educational_programs"
  add_foreign_key "educational_program_perevods", "educational_programs"
  add_foreign_key "educational_program_priems", "educational_programs"
  add_foreign_key "educational_program_researches", "educational_programs"
  add_foreign_key "educational_program_vacants", "educational_programs"
  add_foreign_key "educational_programs", "accreditations"
  add_foreign_key "educational_programs", "attachments"
  add_foreign_key "educational_programs", "educational_standarts"
  add_foreign_key "marks", "educational_programs"
  add_foreign_key "marks", "users"
  add_foreign_key "methodological_supports", "attachments"
  add_foreign_key "methodological_supports", "educational_programs"
  add_foreign_key "practices", "attachments"
  add_foreign_key "practices", "educational_programs"
  add_foreign_key "subjects", "attachments", column: "annotation_attachment_id"
  add_foreign_key "subjects", "educational_programs"
end
