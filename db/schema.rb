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

ActiveRecord::Schema.define(version: 20160616153607) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "badges_sashes", force: :cascade do |t|
    t.integer  "badge_id"
    t.integer  "sash_id"
    t.boolean  "notified_user", default: false
    t.datetime "created_at"
  end

  add_index "badges_sashes", ["badge_id", "sash_id"], name: "index_badges_sashes_on_badge_id_and_sash_id", using: :btree
  add_index "badges_sashes", ["badge_id"], name: "index_badges_sashes_on_badge_id", using: :btree
  add_index "badges_sashes", ["sash_id"], name: "index_badges_sashes_on_sash_id", using: :btree

  create_table "flags", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "flaggable_id"
    t.string   "flaggable_type"
    t.string   "kind",           default: "spam", null: false
    t.string   "description",    default: "",     null: false
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
  end

  add_index "flags", ["flaggable_type", "flaggable_id"], name: "index_flags_on_flaggable_type_and_flaggable_id", using: :btree
  add_index "flags", ["user_id", "flaggable_id", "flaggable_type"], name: "index_flags_on_user_id_and_flaggable_id_and_flaggable_type", unique: true, using: :btree
  add_index "flags", ["user_id"], name: "index_flags_on_user_id", using: :btree

  create_table "ideas", force: :cascade do |t|
    t.string   "title",                                        default: "",    null: false
    t.string   "summary",                                      default: "",    null: false
    t.text     "description",                                  default: "",    null: false
    t.integer  "user_id",                                                      null: false
    t.datetime "created_at",                                                   null: false
    t.datetime "updated_at",                                                   null: false
    t.integer  "positive_votes_count",                         default: 0
    t.integer  "negative_votes_count",                         default: 0
    t.decimal  "balance",              precision: 8, scale: 2, default: 0.0
    t.integer  "flags_count",                                  default: 0,     null: false
    t.boolean  "approved",                                     default: false, null: false
  end

  add_index "ideas", ["user_id"], name: "index_ideas_on_user_id", using: :btree

  create_table "implementations", force: :cascade do |t|
    t.string   "title",       default: "", null: false
    t.string   "summary",     default: "", null: false
    t.text     "description", default: "", null: false
    t.integer  "user_id",                  null: false
    t.integer  "idea_id",                  null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "implementations", ["idea_id"], name: "index_implementations_on_idea_id", using: :btree
  add_index "implementations", ["user_id", "idea_id"], name: "index_implementations_on_user_id_and_idea_id", unique: true, using: :btree
  add_index "implementations", ["user_id"], name: "index_implementations_on_user_id", using: :btree

  create_table "merit_actions", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "action_method"
    t.integer  "action_value"
    t.boolean  "had_errors",    default: false
    t.string   "target_model"
    t.integer  "target_id"
    t.text     "target_data"
    t.boolean  "processed",     default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "merit_activity_logs", force: :cascade do |t|
    t.integer  "action_id"
    t.string   "related_change_type"
    t.integer  "related_change_id"
    t.string   "description"
    t.datetime "created_at"
  end

  create_table "merit_score_points", force: :cascade do |t|
    t.integer  "score_id"
    t.integer  "num_points", default: 0
    t.string   "log"
    t.datetime "created_at"
  end

  create_table "merit_scores", force: :cascade do |t|
    t.integer "sash_id"
    t.string  "category", default: "default"
  end

  create_table "payments", force: :cascade do |t|
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "recipient_id"
    t.string   "recipient_type"
    t.decimal  "amount",         precision: 9, scale: 2, default: 0.0, null: false
    t.string   "paypal_id"
    t.string   "paypal_status"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
  end

  add_index "payments", ["paypal_id"], name: "index_payments_on_paypal_id", using: :btree
  add_index "payments", ["recipient_type", "recipient_id"], name: "index_payments_on_recipient_type_and_recipient_id", using: :btree
  add_index "payments", ["sender_type", "sender_id"], name: "index_payments_on_sender_type_and_sender_id", using: :btree

  create_table "sashes", force: :cascade do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "subscribers", force: :cascade do |t|
    t.string   "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                                          default: "",    null: false
    t.string   "name",                                           default: "",    null: false
    t.string   "encrypted_password",                             default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                                  default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "provider"
    t.string   "uid"
    t.datetime "created_at",                                                     null: false
    t.datetime "updated_at",                                                     null: false
    t.integer  "sash_id"
    t.integer  "level",                                          default: 0
    t.boolean  "admin",                                          default: false
    t.decimal  "balance",                precision: 8, scale: 2, default: 0.0
    t.boolean  "active",                                         default: true,  null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["provider"], name: "index_users_on_provider", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["uid"], name: "index_users_on_uid", using: :btree

  create_table "votes", force: :cascade do |t|
    t.integer  "positive_idea_id", null: false
    t.integer  "negative_idea_id", null: false
    t.integer  "user_id",          null: false
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "votes", ["negative_idea_id"], name: "index_votes_on_negative_idea_id", using: :btree
  add_index "votes", ["positive_idea_id"], name: "index_votes_on_positive_idea_id", using: :btree
  add_index "votes", ["user_id"], name: "index_votes_on_user_id", using: :btree

  add_foreign_key "flags", "users"
  add_foreign_key "implementations", "ideas"
  add_foreign_key "implementations", "users"
  add_foreign_key "votes", "users"
end
