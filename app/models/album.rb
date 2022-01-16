class Album < ApplicationRecord
  has_many :artist_albums
  has_many :artists, through: :artist_albums

  has_many :songs

  validates :name, presence: true
  validates :spotify_id, presence: true
  validates :spotify_url, presence: true
  validates :total_tracks, presence: true
end
