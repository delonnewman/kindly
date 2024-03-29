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

ActiveRecord::Schema[7.1].define(version: 2024_02_06_162245) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "dashboards", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_dashboards_on_user_id"
  end

  create_table "groups", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_groups_on_name", unique: true
    t.index ["team_id"], name: "index_groups_on_team_id"
  end

  create_table "invoices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "project_id", null: false
    t.string "number", null: false
    t.date "start_on", null: false
    t.date "end_on", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["end_on"], name: "index_invoices_on_end_on"
    t.index ["number"], name: "index_invoices_on_number"
    t.index ["project_id"], name: "index_invoices_on_project_id"
    t.index ["start_on"], name: "index_invoices_on_start_on"
  end

  create_table "projects", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.bigint "group_id", null: false
    t.string "name", null: false
    t.integer "rounding_factor", default: 15, null: false
    t.boolean "billable", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.money "doller_pay_rate", scale: 2, default: "75.0", null: false
    t.decimal "pay_rate_amount", default: "75.0", null: false
    t.string "pay_rate_unit", default: "per_hour", null: false
    t.index ["billable"], name: "index_projects_on_billable"
    t.index ["group_id"], name: "index_projects_on_group_id"
    t.index ["name"], name: "index_projects_on_name"
    t.index ["rounding_factor"], name: "index_projects_on_rounding_factor"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_teams_on_name", unique: true
  end

  create_table "time_entries", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "project_id", null: false
    t.bigint "user_id", null: false
    t.integer "minutes"
    t.string "description"
    t.boolean "invoiced", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "status", default: 0, null: false
    t.datetime "started_at", precision: nil
    t.index ["invoiced"], name: "index_time_entries_on_invoiced"
    t.index ["minutes"], name: "index_time_entries_on_minutes"
    t.index ["project_id"], name: "index_time_entries_on_project_id"
    t.index ["user_id"], name: "index_time_entries_on_user_id"
  end

  create_table "timers", force: :cascade do |t|
    t.uuid "project_id", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "ended_at", precision: nil
    t.index ["project_id"], name: "index_timers_on_project_id"
  end

  create_table "users", force: :cascade do |t|
    t.bigint "team_id", null: false
    t.string "name"
    t.string "login", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["team_id"], name: "index_users_on_team_id"
  end

  create_table "widget_placements", force: :cascade do |t|
    t.bigint "dashboard_id", null: false
    t.string "widget_class_name", null: false
    t.integer "position_horizontal", null: false
    t.integer "position_vertical", null: false
    t.json "meta_data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dashboard_id"], name: "index_widget_placements_on_dashboard_id"
  end

  add_foreign_key "dashboards", "users"
  add_foreign_key "groups", "teams"
  add_foreign_key "invoices", "projects"
  add_foreign_key "projects", "groups"
  add_foreign_key "time_entries", "projects"
  add_foreign_key "time_entries", "users"
  add_foreign_key "timers", "projects"
  add_foreign_key "users", "teams"
  add_foreign_key "widget_placements", "dashboards"
end
