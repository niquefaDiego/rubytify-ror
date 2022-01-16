require 'test_helper'

class AlbumTest < ActiveSupport::TestCase
  valid_album_data = {
    name: "Super hit album",
    image_url: "https://iamges.spotify.com/dope-album-cover.jpeg",
    spotify_url: "https://albums.spotify.com/super-hit-album.html",
    spotify_id: "s9dabm324",
    total_tracks: 9
  }

  test "should not save album without a name" do
    album = Album.new valid_album_data.except :name
    assert_not album.save
  end

  test "should not save album without a spotify_url" do
    album = Album.new valid_album_data.except :spotify_url
    assert_not album.save
  end

  test "should not save album without a spotify_id" do
    album = Album.new valid_album_data.except :spotify_id
    assert_not album.save
  end

  test "should create an album with valid fields" do
    album = Album.new valid_album_data
    assert album.save
  end
end
