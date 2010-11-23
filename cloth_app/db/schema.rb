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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20101123103320) do

  create_table "addresses", :force => true do |t|
    t.integer  "user_id"
    t.string   "receiver"
    t.string   "receiver_additonal"
    t.string   "street_and_number"
    t.string   "postcode"
    t.string   "town"
    t.string   "land"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "kind",               :limit => 1
  end

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "contents", :force => true do |t|
    t.string   "title"
    t.string   "subtitle"
    t.text     "article"
    t.string   "image_file_name"
    t.string   "link"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "category_id"
    t.string   "link_name"
    t.boolean  "published"
  end

  create_table "options", :force => true do |t|
    t.boolean  "sex"
    t.boolean  "name"
    t.boolean  "address"
    t.boolean  "date_of_birth"
    t.boolean  "telephone"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id",                    :null => false
    t.boolean  "first_letter_of_first_name"
    t.boolean  "first_letter_of_last_name"
    t.boolean  "first_name"
  end

  create_table "order_bill_numbers", :force => true do |t|
    t.integer  "number"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "orders", :force => true do |t|
    t.string   "order_number",                     :null => false
    t.string   "package_number",                   :null => false
    t.integer  "user_id",                          :null => false
    t.integer  "package_id",                       :null => false
    t.integer  "evaluation"
    t.text     "eva_notice"
    t.date     "eva_date_created_at"
    t.date     "eva_date_updated_at"
    t.text     "notice"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "bill_number",                      :null => false
    t.integer  "received",            :limit => 1
  end

  create_table "packages", :force => true do |t|
    t.string   "name"
    t.integer  "size"
    t.integer  "next_size"
    t.integer  "age"
    t.string   "saison"
    t.text     "kind"
    t.integer  "amount_clothes"
    t.string   "label"
    t.integer  "amount_labels"
    t.string   "colors"
    t.text     "notice"
    t.boolean  "sex"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.string   "serial_number"
    t.integer  "state",          :limit => 1, :default => 0
  end

  create_table "users", :force => true do |t|
    t.string   "login",                     :limit => 40
    t.string   "name",                      :limit => 100, :default => ""
    t.string   "email",                     :limit => 100
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token",            :limit => 40
    t.datetime "remember_token_expires_at"
    t.string   "activation_code",           :limit => 40
    t.datetime "activated_at"
    t.string   "state",                                    :default => "passive"
    t.datetime "deleted_at"
    t.string   "role"
    t.integer  "roles_mask"
    t.string   "first_name"
    t.string   "last_name"
    t.date     "date_of_birth"
    t.string   "telephone"
    t.string   "user_number"
    t.boolean  "sex"
    t.date     "start_holidays"
    t.date     "end_holidays"
  end

  add_index "users", ["login"], :name => "index_users_on_login", :unique => true

end
