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

ActiveRecord::Schema.define(version: 20151203183738) do

  create_table "background_images", force: :cascade do |t|
    t.integer  "song_id"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "background_images", ["song_id"], name: "index_background_images_on_song_id"

  create_table "metadata", force: :cascade do |t|
    t.integer  "song_id"
    t.integer  "metadata_field_id"
    t.string   "value"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  add_index "metadata", ["metadata_field_id"], name: "index_metadata_on_metadata_field_id"
  add_index "metadata", ["song_id"], name: "index_metadata_on_song_id"

  create_table "metadata_fields", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "songs", force: :cascade do |t|
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.integer  "artist_metadata_id"
    t.integer  "title_metadata_id"
  end

  add_index "songs", ["artist_metadata_id"], name: "index_songs_on_artist_metadata_id"
  add_index "songs", ["title_metadata_id"], name: "index_songs_on_title_metadata_id"

end
