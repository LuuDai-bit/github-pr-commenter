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

ActiveRecord::Schema[8.1].define(version: 2026_02_19_023400) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "comment_templates", force: :cascade do |t|
    t.text "content", null: false
    t.datetime "created_at", null: false
    t.bigint "repository_id", null: false
    t.string "status", default: "draft", null: false
    t.datetime "updated_at", null: false
    t.index ["repository_id"], name: "index_comment_templates_on_repository_id"
  end

  create_table "github_auth_tokens", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "expire_date"
    t.string "token", null: false
    t.datetime "updated_at", null: false
  end

  create_table "repositories", force: :cascade do |t|
    t.string "added_method", default: "auto", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "owner", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "comment_templates", "repositories"
end
