module Api
  module V1
    class AlbumsController < ApplicationController
      def list_songs
        album = Album.find_by spotify_id: params[:id]
        songs = album.songs.all.select(:name, :spotify_url, :preview_url, :duration_ms, :explicit)
        render json: songs.as_json(:except => :id)
      end
    end
  end
end