class Album < ApplicationRecord
  belongs_to :artist
  serialize :genres, Array
end
