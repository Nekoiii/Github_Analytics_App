# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2023_11_16_063944) do
  create_table "organization_users", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "organization_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organization_id"], name: "index_organization_users_on_organization_id"
    t.index ["user_id"], name: "index_organization_users_on_user_id"
  end

  create_table "organizations", charset: "utf8mb4", force: :cascade do |t|
    t.string "github_login"
    t.string "avatar_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pull_requests", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "repository_id", null: false
    t.bigint "author_id"
    t.bigint "merger_id"
    t.string "github_id"
    t.string "title"
    t.string "permalink"
    t.string "base_ref_name"
    t.string "base_ref_oid"
    t.string "head_ref_name"
    t.string "head_ref_oid"
    t.integer "number"
    t.text "merge_commit"
    t.boolean "is_draft"
    t.boolean "closed"
    t.boolean "merged"
    t.datetime "merged_at"
    t.datetime "closed_at"
    t.datetime "github_created_at"
    t.datetime "github_updated_at"
    t.datetime "github_published_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_pull_requests_on_author_id"
    t.index ["merger_id"], name: "index_pull_requests_on_merger_id"
    t.index ["repository_id"], name: "index_pull_requests_on_repository_id"
  end

  create_table "repositories", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "owner_id"
    t.string "github_id"
    t.string "name"
    t.string "url"
    t.text "description"
    t.datetime "github_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "owner_type"
    t.index ["owner_id", "owner_type"], name: "index_repositories_on_owner_id_and_owner_type"
    t.index ["owner_id"], name: "index_repositories_on_owner_id"
  end

  create_table "reviews", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "pull_request_id"
    t.bigint "author_id"
    t.integer "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_id"], name: "index_reviews_on_author_id"
    t.index ["pull_request_id"], name: "index_reviews_on_pull_request_id"
  end

  create_table "statistics", charset: "utf8mb4", force: :cascade do |t|
    t.bigint "repository_id"
    t.bigint "user_id"
    t.boolean "is_overall", default: true
    t.integer "year"
    t.integer "month"
    t.integer "created_pr_count", default: 0
    t.integer "merged_pr_count", default: 0
    t.integer "closed_pr_count", default: 0
    t.integer "open_pr_count", default: 0
    t.integer "draft_pr_count", default: 0
    t.integer "approval_count", default: 0
    t.float "average_close_time"
    t.float "average_merge_time"
    t.float "average_merge_main_time"
    t.float "total_close_time"
    t.float "total_merge_time"
    t.float "total_merge_main_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["repository_id"], name: "index_statistics_on_repository_id"
    t.index ["user_id"], name: "index_statistics_on_user_id"
  end

  create_table "users", charset: "utf8mb4", force: :cascade do |t|
    t.string "github_login"
    t.string "avatar_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", default: "", null: false
    t.string "password"
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "provider", default: ""
    t.string "uid", default: ""
  end

  add_foreign_key "organization_users", "organizations"
  add_foreign_key "organization_users", "users"
  add_foreign_key "pull_requests", "repositories"
  add_foreign_key "pull_requests", "users", column: "author_id"
  add_foreign_key "pull_requests", "users", column: "merger_id"
  add_foreign_key "repositories", "users", column: "owner_id"
  add_foreign_key "reviews", "pull_requests"
  add_foreign_key "reviews", "users", column: "author_id"
  add_foreign_key "statistics", "repositories"
  add_foreign_key "statistics", "users"
end
