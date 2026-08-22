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

ActiveRecord::Schema[8.1].define(version: 2026_08_21_235047) do
  create_table "activities", force: :cascade do |t|
    t.integer "action_type"
    t.datetime "created_at", null: false
    t.integer "job_id", null: false
    t.text "notes"
    t.datetime "occurred_at"
    t.datetime "updated_at", null: false
    t.index ["job_id"], name: "index_activities_on_job_id"
  end

  create_table "companies", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "name"
    t.text "notes"
    t.datetime "updated_at", null: false
    t.string "url"
  end

  create_table "contacts", force: :cascade do |t|
    t.integer "company_id", null: false
    t.datetime "created_at", null: false
    t.string "email"
    t.string "name"
    t.text "notes"
    t.string "phone"
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_contacts_on_company_id"
  end

  create_table "jobs", force: :cascade do |t|
    t.date "applied_on"
    t.integer "company_id", null: false
    t.datetime "created_at", null: false
    t.string "location"
    t.text "notes"
    t.string "salary_info"
    t.integer "status"
    t.string "title"
    t.datetime "updated_at", null: false
    t.string "url"
    t.string "work_model"
    t.index ["company_id"], name: "index_jobs_on_company_id"
  end

  add_foreign_key "activities", "jobs"
  add_foreign_key "contacts", "companies"
  add_foreign_key "jobs", "companies"
end
