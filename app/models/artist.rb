class Artist < ApplicationRecord
  has_many :artist_albums
  has_many :albums, through: :artist_albums

  has_many :artist_genres, :dependent => :destroy


  validates :name, presence: true
  validates :spotify_id, presence: true
  validates :spotify_url, presence: true

end
