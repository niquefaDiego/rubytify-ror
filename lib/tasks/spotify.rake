require 'net/http'
require 'singleton'

class SpotifyAPI
  include Singleton

  def list_tracks(track_ids)
  end

  def list_artist_albums(artist_id)
    # https://developer.spotify.com/documentation/web-api/reference/#/operations/get-an-albums-tracks
    get_all "/v1/artists/#{artist_id}/albums?limit=50"
  end

  def list_album_tracks(album_id)
    # https://developer.spotify.com/documentation/web-api/reference/#/operations/get-an-artists-albums
    get_all "/v1/albums/#{album_id}/tracks?limit=50"
  end

  def find_artist(artist_name)
    # https://developer.spotify.com/documentation/web-api/reference/#/operations/search
    query_string = "type=artist&limit=1&offset=0&q=#{artist_name}"
    search_response = get_request "/v1/search?#{query_string}"
    search_response['artists']['items'][0]
  end

  private
    # Uses Spotify API's pagination to get all items from a list endpoint.
    def get_all(request_uri)
      all_items = []
      while request_uri != nil do
        page = get_request request_uri
        all_items += page['items']
        request_uri = page['next']
      end
      
      all_items
    end

    # Does a get request, adding an authentication header and retries with exponential backoff.
    def get_request(req_path)
      spotify_api_url = ENV['SPOTIFY_API_URL']
      uri = nil
      if req_path.starts_with? spotify_api_url then
        uri = URI.parse(req_path)
      else
        uri = URI.parse("#{spotify_api_url}#{req_path}")
      end

      backoff_time = 1
      while true do
        response = Net::HTTP.start(uri.host, uri.port, :use_ssl => true) {|http|
          request = Net::HTTP::Get.new(uri)
          request['authorization'] = get_authorization_header
          http.request(request)
        }

        if response.code.to_s == "200" then          
          return JSON.parse(response.body)
        elsif response.code.to_s == "429" then
          # https://developer.spotify.com/documentation/web-api/guides/rate-limits/
          puts "Error 429: Retrying request after #{backoff_time} seconds"
          sleep backoff_time
          backoff_time = [30, 2*backoff_time].min
        else
          puts "Error #{response.code}: #{response.message}. Body=#{response.body}"
          # TODO: improve exception types and handling
          raise Exception.new "Spotify API error"
        end
      end
    end

    def get_authorization_header
      if @authorization_header != nil && @expires_at > Time.now() then
        return @authorization_header
      end

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
      @expires_at = Time.now() + json_response['expires_in'].to_i - 30

      @authorization_header = "#Bearer #{json_response['access_token']}"
    end
end

def import_artist(artist_name)
  puts "Importing artist #{artist_name}"
  artist_hash = SpotifyAPI.instance.find_artist artist_name
  artist_spotify_id = artist_hash['id']
  artist_data = {
    name: artist_hash['name'],
    image_url: artist_hash['images'][0]['url'],
    popularity: artist_hash['popularity'],
    spotify_url: artist_hash['external_urls']['spotify'],
    spotify_id: artist_spotify_id
  }
  artist = Artist.find_by(spotify_id: artist_spotify_id)
  if artist == nil then
    artist = Artist.create! artist_data
  else
    artist.update! artist_data
  end
  artist_hash['genres'].each do |genre|
    artist_genre = artist.artist_genres.find_by(genre: genre)
    if artist_genre == nil then
      artist.artist_genres.create!(genre: genre)
    end
  end
  artist
end

def import_album_songs(album)
  puts "-> Fetching album #{album.name}. SpotifyID: #{album.spotify_id}"
  songs_hash_list = SpotifyAPI.instance.list_album_tracks album.spotify_id
  songs_hash_list.each do |song_hash|
    song_spotify_id = song_hash['id']
    song_data = {
      spotify_id: song_spotify_id,
      album_id: album.id,
      name: song_hash['name'],
      spotify_url: song_hash['external_urls']['spotify'],
      preview_url: song_hash['preview_url'],
      duration_ms: song_hash['duration_ms'],
      explicit: song_hash['explicit'],
    }

    song = Song.find_by(spotify_id: song_spotify_id)
    if song == nil then
      song = Song.create! song_data
    else
      song.update! song_data
    end
  end
end

def import_artist_albums(artist)
  puts "Importing albums of #{artist.name} (ID: #{artist.id}, SpotifyID: #{artist.spotify_id}"
  albums_hash_list = SpotifyAPI.instance.list_artist_albums artist.spotify_id
  puts "Found #{albums_hash_list.length} albums for #{artist.name}"
  albums_hash_list.each do |album_hash|
    album_spotify_id = album_hash['id']
    album_hash_images = album_hash['images']
    album_data = {
      name: album_hash['name'],
      image_url: album_hash_images.length > 0 ? album_hash_images[0]['url'] : nil,
      spotify_url: album_hash['external_urls']['spotify'],
      total_tracks: album_hash['total_tracks'],
      spotify_id: album_spotify_id
    }
    album = Album.find_by(spotify_id: album_spotify_id)
    if album == nil then
      album = Album.create! album_data
    else
      album.update! album_data
    end
    artist_album = ArtistAlbum.find_by(artist_id: artist.id, album_id: album.id)
    if artist_album == nil then
      artist_album = ArtistAlbum.create!(artist_id: artist.id, album_id: album.id)
    end
    import_album_songs album
  end
end

namespace :spotify do
  task :import => :environment do
    env_file = File.join(Rails.root, 'lib', 'tasks', 'spotify_artists.yml')
    artist_names = YAML.load(File.open(env_file))['artists']
    artist_names.each do |artist_name|
      artist = import_artist artist_name
      import_artist_albums artist
    end
  end
end

