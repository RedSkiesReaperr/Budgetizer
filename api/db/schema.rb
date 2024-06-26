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

ActiveRecord::Schema[7.0].define(version: 2024_04_01_073839) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: :cascade do |t|
    t.bigint "user_id"
    t.string "key", null: false
    t.string "color", null: false
    t.string "icon", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["key", "user_id"], name: "index_categories_on_key_and_user_id", unique: true
    t.index ["user_id"], name: "index_categories_on_user_id"
  end

  create_table "import_configs", force: :cascade do |t|
    t.string "value", null: false
    t.bigint "category_id"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_import_configs_on_category_id"
    t.index ["user_id"], name: "index_import_configs_on_user_id"
  end

  create_table "lines", force: :cascade do |t|
    t.string "label", null: false
    t.float "amount", null: false
    t.integer "line_type", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "category_id"
    t.index ["category_id"], name: "index_lines_on_category_id"
    t.index ["user_id"], name: "index_lines_on_user_id"
  end

  create_table "notes", force: :cascade do |t|
    t.string "title", null: false
    t.text "description", null: false
    t.integer "month", null: false
    t.integer "year", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "objectives", force: :cascade do |t|
    t.integer "vital", null: false
    t.integer "non_essential", null: false
    t.integer "saving", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_objectives_on_user_id", unique: true
  end

  create_table "operation_import_configs", force: :cascade do |t|
    t.string "attribute", null: false
    t.integer "attribute_type", null: false
    t.integer "condition", null: false
    t.string "value", null: false
    t.bigint "category_id"
    t.integer "operation_type"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_operation_import_configs_on_category_id"
    t.index ["user_id"], name: "index_operation_import_configs_on_user_id"
  end

  create_table "operations", force: :cascade do |t|
    t.datetime "date", null: false
    t.string "label", null: false
    t.float "amount", null: false
    t.string "comment"
    t.boolean "pointed", default: false, null: false
    t.integer "op_type", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "category_id"
    t.index ["category_id"], name: "index_operations_on_category_id"
    t.index ["user_id"], name: "index_operations_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "provider", default: "email", null: false
    t.string "uid", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.boolean "allow_password_change", default: false
    t.datetime "remember_created_at"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "name"
    t.string "nickname"
    t.string "email"
    t.json "tokens"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
  end

  add_foreign_key "categories", "users"
  add_foreign_key "import_configs", "categories"
  add_foreign_key "import_configs", "users"
  add_foreign_key "lines", "categories"
  add_foreign_key "lines", "users"
  add_foreign_key "notes", "users"
  add_foreign_key "objectives", "users"
  add_foreign_key "operation_import_configs", "categories"
  add_foreign_key "operation_import_configs", "users"
  add_foreign_key "operations", "categories"
  add_foreign_key "operations", "users"
end
