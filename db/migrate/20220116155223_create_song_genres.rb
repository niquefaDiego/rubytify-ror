class CreateSongGenres < ActiveRecord::Migration[5.2]
  def change
    create_table :song_genres do |t|
      t.references :song, foreign_key: true
      t.string :genre

      t.timestamps
    end
    add_index :song_genres, :genre
  end
end
