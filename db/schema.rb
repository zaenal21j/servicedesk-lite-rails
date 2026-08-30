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

ActiveRecord::Schema[8.1].define(version: 2026_08_28_000080) do
  create_table "audit_logs", force: :cascade do |t|
    t.string "action", null: false
    t.datetime "created_at", null: false
    t.text "metadata", default: "{}", null: false
    t.integer "record_id", null: false
    t.string "record_type", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id", null: false
    t.integer "workspace_id", null: false
    t.index ["record_type", "record_id"], name: "index_audit_logs_on_record_type_and_record_id"
    t.index ["user_id"], name: "index_audit_logs_on_user_id"
    t.index ["workspace_id"], name: "index_audit_logs_on_workspace_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "company"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.string "phone"
    t.datetime "updated_at", null: false
    t.integer "workspace_id", null: false
    t.index ["workspace_id"], name: "index_customers_on_workspace_id"
  end

  create_table "tickets", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "customer_id", null: false
    t.text "description"
    t.string "priority"
    t.string "status"
    t.string "subject"
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_tickets_on_customer_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "api_token"
    t.datetime "created_at", null: false
    t.string "email", null: false
    t.string "password_digest", null: false
    t.string "role", default: "viewer", null: false
    t.datetime "updated_at", null: false
    t.integer "workspace_id", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["api_token"], name: "index_users_on_api_token", unique: true
    t.index ["workspace_id"], name: "index_users_on_workspace_id"
  end

  create_table "workspaces", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.string "slug", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_workspaces_on_slug", unique: true
  end

  add_foreign_key "tickets", "customers"
  add_foreign_key "customers", "workspaces"
  add_foreign_key "users", "workspaces"
  add_foreign_key "audit_logs", "users"
  add_foreign_key "audit_logs", "workspaces"
end
