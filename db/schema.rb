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

ActiveRecord::Schema[7.1].define(version: 2023_12_20_161748) do
  create_table "classifications", force: :cascade do |t|
    t.integer "trial_id"
    t.integer "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_classifications_on_tag_id"
    t.index ["trial_id"], name: "index_classifications_on_trial_id"
  end

  create_table "experiment_tags", force: :cascade do |t|
    t.integer "experiment_id"
    t.integer "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["experiment_id"], name: "index_experiment_tags_on_experiment_id"
    t.index ["tag_id"], name: "index_experiment_tags_on_tag_id"
  end

  create_table "experiments", force: :cascade do |t|
    t.string "name"
    t.boolean "disabled"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "experiments_robots", id: false, force: :cascade do |t|
    t.integer "experiment_id", null: false
    t.integer "robot_id", null: false
    t.index ["experiment_id", "robot_id"], name: "index_experiments_robots_on_experiment_id_and_robot_id"
    t.index ["robot_id", "experiment_id"], name: "index_experiments_robots_on_robot_id_and_experiment_id"
  end

  create_table "factors", force: :cascade do |t|
    t.string "name"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "robots", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "trial_executions", force: :cascade do |t|
    t.string "status"
    t.text "log"
    t.integer "trial_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["trial_id"], name: "index_trial_executions_on_trial_id"
  end

  create_table "trial_factors", force: :cascade do |t|
    t.integer "factor_id"
    t.integer "trial_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["factor_id"], name: "index_trial_factors_on_factor_id"
    t.index ["trial_id"], name: "index_trial_factors_on_trial_id"
  end

  create_table "trials", force: :cascade do |t|
    t.string "name"
    t.boolean "disabled"
    t.boolean "deleted"
    t.integer "runs"
    t.integer "experiment_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["experiment_id"], name: "index_trials_on_experiment_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
