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

ActiveRecord::Schema[7.0].define(version: 2022_10_12_142741) do
  create_table "bank_accounts", force: :cascade do |t|
    t.integer "account_number", null: false
    t.string "agency", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["account_number", "agency"], name: "index_bank_accounts_on_account_number_and_agency", unique: true
    t.index ["deleted_at"], name: "index_bank_accounts_on_deleted_at"
    t.index ["user_id"], name: "index_bank_accounts_on_user_id"
  end

  create_table "bank_transactions", force: :cascade do |t|
    t.string "description"
    t.string "kind", null: false
    t.string "status", null: false
    t.integer "value", null: false
    t.integer "bank_account_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bank_account_id"], name: "index_bank_transactions_on_bank_account_id"
    t.index ["kind"], name: "index_bank_transactions_on_kind"
    t.index ["status"], name: "index_bank_transactions_on_status"
    t.index ["user_id"], name: "index_bank_transactions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "bank_accounts", "users"
  add_foreign_key "bank_transactions", "bank_accounts"
  add_foreign_key "bank_transactions", "users"
end
