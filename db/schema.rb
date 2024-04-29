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

ActiveRecord::Schema[7.1].define(version: 2024_04_22_193143) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "attendance_records", force: :cascade do |t|
    t.string "user_id"
    t.integer "schedule_id"
    t.integer "project_id"
    t.datetime "checkin"
    t.boolean "approval_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "project_members", force: :cascade do |t|
    t.string "user_id"
    t.integer "project_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "projects", force: :cascade do |t|
    t.integer "project_id"
    t.string "leader_id"
    t.string "project_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "scheduled_workdays", force: :cascade do |t|
    t.string "program_manager_id"
    t.integer "project_id"
    t.date "day"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "training_courses", force: :cascade do |t|
    t.string "name"
    t.integer "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "training_enrollments", force: :cascade do |t|
    t.integer "course_id"
    t.integer "user_id"
    t.datetime "completion_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "uid"
    t.string "avatar_url"
    t.string "full_name"
    t.string "role"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
end
