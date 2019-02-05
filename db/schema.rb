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

ActiveRecord::Schema.define(version: 2019_02_05_184430) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "answers", force: :cascade do |t|
    t.text "body"
    t.bigint "user_id"
    t.bigint "question_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_answers_on_question_id"
    t.index ["user_id"], name: "index_answers_on_user_id"
  end

  create_table "course_members", force: :cascade do |t|
    t.integer "role"
    t.bigint "user_id"
    t.bigint "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_course_members_on_course_id"
    t.index ["user_id"], name: "index_course_members_on_user_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "expertises", force: :cascade do |t|
    t.bigint "course_id"
    t.bigint "tutor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_expertises_on_course_id"
    t.index ["tutor_id"], name: "index_expertises_on_tutor_id"
  end

  create_table "interests", force: :cascade do |t|
    t.bigint "teaching_session_id"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["teaching_session_id"], name: "index_interests_on_teaching_session_id"
    t.index ["user_id"], name: "index_interests_on_user_id"
  end

  create_table "questions", force: :cascade do |t|
    t.string "title"
    t.text "body"
    t.boolean "anonymous"
    t.bigint "user_id"
    t.bigint "course_id"
    t.bigint "teaching_session_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_questions_on_course_id"
    t.index ["teaching_session_id"], name: "index_questions_on_teaching_session_id"
    t.index ["user_id"], name: "index_questions_on_user_id"
  end

  create_table "reports", force: :cascade do |t|
    t.integer "students"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.bigint "topic_id"
    t.bigint "report_id"
    t.bigint "question_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_tags_on_question_id"
    t.index ["report_id"], name: "index_tags_on_report_id"
    t.index ["topic_id"], name: "index_tags_on_topic_id"
  end

  create_table "teaching_sessions", force: :cascade do |t|
    t.time "start_time"
    t.bigint "tutor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tutor_id"], name: "index_teaching_sessions_on_tutor_id"
  end

  create_table "topics", force: :cascade do |t|
    t.string "name"
    t.bigint "course_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_topics_on_course_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "password_digest"
    t.integer "role", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_token_expires_at"
    t.index ["email"], name: "index_users_on_email"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token"
  end

  add_foreign_key "answers", "questions"
  add_foreign_key "answers", "users"
  add_foreign_key "course_members", "courses"
  add_foreign_key "course_members", "users"
  add_foreign_key "expertises", "courses"
  add_foreign_key "expertises", "users", column: "tutor_id"
  add_foreign_key "interests", "teaching_sessions"
  add_foreign_key "interests", "users"
  add_foreign_key "questions", "courses"
  add_foreign_key "questions", "teaching_sessions"
  add_foreign_key "questions", "users"
  add_foreign_key "tags", "questions"
  add_foreign_key "tags", "reports"
  add_foreign_key "tags", "topics"
  add_foreign_key "teaching_sessions", "users", column: "tutor_id"
  add_foreign_key "topics", "courses"
end
