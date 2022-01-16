module Api
  module V1
    class ArtistsController < ApplicationController
      def list
        all_artists = Artist.order("popularity DESC").all.map do |artist|
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
      end
    end
  end
end
