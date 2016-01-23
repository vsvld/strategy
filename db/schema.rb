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

ActiveRecord::Schema.define(version: 20160123214940) do

  create_table "companies", force: :cascade do |t|
    t.string   "name"
    t.string   "code"
    t.text     "details"
    t.integer  "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "companies", ["user_id"], name: "index_companies_on_user_id"

  create_table "concrete_strategies", force: :cascade do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "strategy_model_id"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "concrete_strategies", ["strategy_model_id"], name: "index_concrete_strategies_on_strategy_model_id"

  create_table "financial_indicators", force: :cascade do |t|
    t.string   "name"
    t.float    "value"
    t.string   "units"
    t.integer  "period_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "financial_indicators", ["period_id"], name: "index_financial_indicators_on_period_id"

  create_table "integral_indicators", force: :cascade do |t|
    t.float    "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "periods", force: :cascade do |t|
    t.string   "period_type"
    t.date     "date_from"
    t.date     "date_to"
    t.integer  "company_id"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "periods", ["company_id"], name: "index_periods_on_company_id"

  create_table "periods_groups", force: :cascade do |t|
    t.string   "period_type"
    t.date     "date_from"
    t.date     "date_to"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  create_table "pgis", force: :cascade do |t|
    t.integer  "periods_group_id"
    t.integer  "period_id"
    t.integer  "integral_indicator_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
  end

  add_index "pgis", ["integral_indicator_id"], name: "index_pgis_on_integral_indicator_id"
  add_index "pgis", ["period_id"], name: "index_pgis_on_period_id"
  add_index "pgis", ["periods_group_id"], name: "index_pgis_on_periods_group_id"

  create_table "strategies", force: :cascade do |t|
    t.string   "name"
    t.string   "description"
    t.integer  "company_id"
    t.integer  "strategy_model_id"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
    t.float    "forecast"
    t.float    "profitability_average_growth"
    t.integer  "periods_group_id"
    t.integer  "concrete_strategy_id"
  end

  add_index "strategies", ["company_id"], name: "index_strategies_on_company_id"
  add_index "strategies", ["concrete_strategy_id"], name: "index_strategies_on_concrete_strategy_id"
  add_index "strategies", ["periods_group_id"], name: "index_strategies_on_periods_group_id"
  add_index "strategies", ["strategy_model_id"], name: "index_strategies_on_strategy_model_id"

  create_table "strategy_models", force: :cascade do |t|
    t.string   "name"
    t.integer  "strategy_type_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
  end

  add_index "strategy_models", ["strategy_type_id"], name: "index_strategy_models_on_strategy_type_id"

  create_table "strategy_types", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.string   "first_name"
    t.string   "last_name"
    t.string   "organisation"
    t.string   "email",                          null: false
    t.string   "encrypted_password", limit: 128, null: false
    t.string   "confirmation_token", limit: 128
    t.string   "remember_token",     limit: 128, null: false
  end

  add_index "users", ["email"], name: "index_users_on_email"
  add_index "users", ["remember_token"], name: "index_users_on_remember_token"

end
