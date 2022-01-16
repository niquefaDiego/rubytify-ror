module Api
  module V1
    class AlbumsController < ApplicationController
      def list_songs
        album = Album.find_by spotify_id: params[:id]
      end
    end
  end
end