module Api
  module V1
    class ArtistsController < ApplicationController
      def list
        all_artists = Artist.order("popularity DESC")
          .all.map do |artist|
          {
            id: artist.spotify_id,
            name: artist.name,
            image: artist.image_url,
            genres: artist.artist_genres.map { |x| x.genre },
            popularity: artist.popularity,
            spotify_url: artist.spotify_url,
          }
        end
        render json: all_artists
      end

      def list_albums
        artist = Artist.find_by spotify_id: params[:id]
        all_artist_albums = artist.albums.all.select(:spotify_id, :name, :image_url, :spotify_url, :total_tracks)
        all_artist_albums = all_artist_albums.map do |album|
          {
            id: album.spotify_id,
            name: album.name,
            image: album.image_url,
            spotify_url: album.spotify_url,
            total_tracks: album.total_tracks
          }
        end
        render json: all_artist_albums
      end
    end
  end
end
