class CreateArtists < ActiveRecord::Migration[5.2]
  def change
    create_table :artists do |t|
      t.string :name
      t.text :image_url
      t.string :genres
      t.integer :popularity
      t.text :spotify_url
      t.string :spotify_id

      t.timestamps
    end
    add_index :artists, :popularity
    add_index :artists, :spotify_id, unique: true
  end
end
