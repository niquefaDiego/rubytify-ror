module Api
  module V1
    class AlbumsController < ApplicationController
      def list_songs
        album = Album.find_by spotify_id: params[:id]
        if album == nil then
          render json: { message: "Album not found" }, status: :not_found
          return
        end
        songs = album.songs.all.select(:name, :spotify_url, :preview_url, :duration_ms, :explicit)
        render json: songs.as_json(:except => :id)
      end
    end
  end
end