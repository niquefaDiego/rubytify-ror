class ArtistGenre < ApplicationRecord
  belongs_to :artist

  validates :genre, presence: true
  validates :artist_id, presence: true

  before_save {
    genre.downcase!
  }
end
