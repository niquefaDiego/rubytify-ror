class CreateArtistGenres < ActiveRecord::Migration[5.2]
  def change
    create_table :artist_genres do |t|
      t.references :artist, foreign_key: true
      t.string :genre

      t.timestamps
    end
    add_index :artist_genres, :genre
    add_index :artist_genres, [:artist_id, :genre], unique: true
  end
end
