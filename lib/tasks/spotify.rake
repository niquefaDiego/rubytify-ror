require 'net/http'
require 'singleton'

class SpotifyAPI
  include Singleton

  def list_artist_albums(artist_id)
    # https://developer.spotify.com/documentation/web-api/reference/#/operations/get-an-albums-tracks
    get_request "/v1/artists/#{artist_id}/albums?limit=50"
  end

  def list_album_tracks(album_id)
    # https://developer.spotify.com/documentation/web-api/reference/#/operations/get-an-artists-albums
    get_request "/v1/albums/#{album_id}/tracks?limit=50"
  end

  def find_artist(artist_name)
    # https://developer.spotify.com/documentation/web-api/reference/#/operations/search
    query_string = "type=artist&limit=1&offset=0&q=#{artist_name}"
    search_response = get_request "/v1/search?#{query_string}"
    search_response['artists']['items'][0]
  end

  private
    def get_request(req_path)
      uri= URI.parse("#{ENV['SPOTIFY_API_URL']}#{req_path}")
      response = Net::HTTP.start(uri.host, uri.port, :use_ssl => true) {|http|
        request = Net::HTTP::Get.new(uri)
        request['authorization'] = get_authorization_header
        http.request(request)
      }

      return JSON.parse(response.body)
    end

    def get_authorization_header
      if @authorization_header != nil && @expires_at > Time.now() then
        return @authorization_header
      end

      puts "getting spotify auth token"
      # https://developer.spotify.com/documentation/general/guides/authorization/client-credentials/
      encoded_token = Base64.strict_encode64("#{ENV['SPOTIFY_CLIENT_ID']}:#{ENV['SPOTIFY_CLIENT_SECRET']}")
      header = {'Authorization': "Basic #{encoded_token}"}

      uri = URI.parse(ENV['SPOTIFY_AUTH_ENDPOINT_URL'])
      uri.port = Net::HTTP.https_default_port()

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      request = Net::HTTP::Post.new(uri.request_uri, header)
      request.set_form_data ({ grant_type: 'client_credentials' })
      
      response = http.request(request)
      json_response = JSON.parse(response.body)
      # Invalidate the token 30 seconds before, just in case.
      @expires_at = Time.now() + json_response['expires_at'].to_i - 30

      @authorization_header = "#Bearer #{json_response['access_token']}"
    end
end

def import_artist(artist_name)
  spotify = SpotifyAPI.instance
  artist_hash = spotify.find_artist artist_name
  artist_spotify_id = artist_hash['id']
  artist = Artist.find_by(spotify_id: artist_spotify_id)
  artist_data = {
    name: artist_hash['name'],
    image_url: artist_hash['images'][0]['url'],
    genres: artist_hash['genres'],
    popularity: artist_hash['popularity'],
    spotify_url: artist_hash['external_urls']['spotify'],
    spotify_id: artist_spotify_id
  }
  if artist == nil then
    artist = Artist.create(artist_data)
  else
    artist = Artist.update(artist_data.except :spotify_id)
  end
  artist
end

namespace :spotify do
  task :import => :environment do
    env_file = File.join(Rails.root, 'lib', 'tasks', 'spotify_artists.yml')
    artists_names = YAML.load(File.open(env_file))['artists']
    artists_names.each do |artist_name|
      import_artist artist_name
    end
  end
end

