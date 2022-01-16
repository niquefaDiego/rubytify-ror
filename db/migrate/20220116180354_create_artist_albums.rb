class CreateArtistAlbums < ActiveRecord::Migration[5.2]
  def change
    create_table :artist_albums do |t|
      t.references :artist
      t.references :album
      t.timestamps
    end
    add_index :artist_albums, [:album_id, :artist_id], unique: true
  end
end
