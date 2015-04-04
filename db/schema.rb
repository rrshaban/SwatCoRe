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

ActiveRecord::Schema.define(version: 20150404025611) do

  create_table "departments", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "professors", force: :cascade do |t|
    t.string   "name"
    t.integer  "department_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end    

  add_index "professors", ["department_id"], name: "index_professors_on_department_id"


  create_table "courses", force: :cascade do |t|
    t.string   "name"
    t.string   "crn"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "professor_id"
    t.integer  "department_id"
  end

  add_index "courses", ["crn"],          name: "index_crn_on_courses"
  add_index "courses", ["professor_id"], name: "index_courses_on_professor_id"
  add_index "courses", ["department_id"], name: "index_courses_on_department_id"

  create_table "reviews", force: :cascade do |t|
    t.text     "content"
    t.integer  "clarity"
    t.integer  "intensity"
    t.integer  "worthit"
    t.integer  "user_id"
    t.integer  "course_id"
    t.integer  "professor_id"
    t.integer  "department_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "reviews", ["course_id"], name: "index_reviews_on_course_id"
  add_index "reviews", ["user_id"], name: "index_reviews_on_user_id"
  add_index "reviews", ["professor_id"], name: "index_reviews_on_professor_id"
  add_index "reviews", ["department_id"], name: "index_reviews_on_department_id"
  
  create_table "users", force: :cascade do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "password_digest"
    t.string   "remember_digest"
    t.boolean  "admin"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true

end
