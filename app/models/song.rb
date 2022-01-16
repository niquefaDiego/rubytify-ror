class Song < ApplicationRecord
  belongs_to :album

  validates :album_id, presence: true
  validates :name, presence: true
  validates :spotify_url, presence: true
  validates :spotify_id, presence: true
  validates :duration_ms, presence: true
  validates :explicit, inclusion: { in: [true, false] }
end
