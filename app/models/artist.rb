class Artist < ApplicationRecord
  has_many :artist_albums
  has_many :albums, through: :artist_albums

  has_many :artist_genres, :dependent => :destroy
end
