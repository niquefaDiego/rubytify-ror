module Api
  module V1
    class GenresController < ApplicationController
      def random_song
        # All genres are in lowercase
        genre = params[:genre_name].downcase
        
        # Find all of the album IDs and track count for all of
        # the artist of the given genre
        artist_genres = ArtistGenre.where(genre: genre)

        if artist_genres.length == 0 then
          render json: { message: "No song for given genre" }, status: 404
          return
        end
        total_tracks = 0
        albums = []
        accummulated_tracks = []
        artist_genres.each  do |artist_genre|
          artist_genre.artist.albums.select(:id, :total_tracks).each do |album|
            total_tracks += album.total_tracks
            albums <<= album.id
            accummulated_tracks <<= total_tracks
          end
        end

        # Select a random track among all of the albums of artists of the given genre
        random_track_index = rand(0...total_tracks)

        # Find the album ID
        album_index = (0..albums.length).bsearch { |i| accummulated_tracks[i] > random_track_index }
        album_id = albums[album_index]

        # Find the specific track within the album
        random_track_index -= accummulated_tracks[album_index-1] if album_index > 0
        song = Album.find(album_id).songs.offset(random_track_index).
          select(:name, :spotify_url, :preview_url, :duration_ms, :explicit).take

        render json: song.as_json(:except => :id)
      end
    end
  end
end