class ArtistAlbum < ApplicationRecord
  belongs_to :artist
  belongs_to :album

  validates :artist_id, presence: true
  validates :album_id, presence: true
end
