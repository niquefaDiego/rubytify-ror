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

ActiveRecord::Schema.define(version: 2022_01_16_180354) do

  create_table "albums", force: :cascade do |t|
    t.string "name"
    t.text "image_url"
    t.text "spotify_url"
    t.integer "total_tracks"
    t.string "spotify_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["spotify_id"], name: "index_albums_on_spotify_id", unique: true
  end

  create_table "artist_albums", force: :cascade do |t|
    t.integer "artist_id"
    t.integer "album_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["album_id", "artist_id"], name: "index_artist_albums_on_album_id_and_artist_id", unique: true
    t.index ["album_id"], name: "index_artist_albums_on_album_id"
    t.index ["artist_id"], name: "index_artist_albums_on_artist_id"
  end

  create_table "artist_genres", force: :cascade do |t|
    t.integer "artist_id"
    t.string "genre"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["artist_id", "genre"], name: "index_artist_genres_on_artist_id_and_genre", unique: true
    t.index ["artist_id"], name: "index_artist_genres_on_artist_id"
    t.index ["genre"], name: "index_artist_genres_on_genre"
  end

  create_table "artists", force: :cascade do |t|
    t.string "name"
    t.text "image_url"
    t.integer "popularity"
    t.text "spotify_url"
    t.string "spotify_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["popularity"], name: "index_artists_on_popularity"
    t.index ["spotify_id"], name: "index_artists_on_spotify_id", unique: true
  end

  create_table "songs", force: :cascade do |t|
    t.integer "album_id"
    t.string "name"
    t.text "spotify_url"
    t.text "preview_url"
    t.integer "duration_ms"
    t.boolean "explicit"
    t.string "spotify_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["album_id"], name: "index_songs_on_album_id"
    t.index ["spotify_id"], name: "index_songs_on_spotify_id", unique: true
  end

end
