module Api
  module V1
    class ArtistsController < ApplicationController
      def list
        all_artists = Artist.order("popularity DESC")
          .select(:id, :name, :image_url, :artist_genres, :popularity, :spotify_url)
          .all.map do |artist|
          {
            id: artist.id,
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
        artist = Artist.find(params[:id])
        all_artist_albums = artist.albums.all.select(:id, :name, :image_url, :spotify_url, :total_tracks)
        all_artist_albums = all_artist_albums.map do |album|
          {
            id: album.id,
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
