require 'rails_helper'

RSpec.describe 'Random song for genre', type: :request do
  fixtures :artists, :albums, :artist_albums, :artist_genres, :songs
  describe 'GET /api/v1/genres/:genre/random_song for valid genre' do
    before { get '/api/v1/genres/k-pop/random_song' }
    it 'returns a random snog' do
      # Only these 2 are kpop songs
      expect(json['data']['name'] == 'Intro : Persona' || json['data']['name'] == 'Life Goes On').to be true
    end
    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /api/v1/genres/:genre/random_song for a genre with no songs' do
    before { get '/api/v1/genres/joropo/random_song' }
    it 'returns error message' do
      expect(json).not_to be_empty
      expect(json['message']).to eq('No songs for the given genre')
      expect(json.size).to eq(1)
    end
    it 'returns status code 404' do
      expect(response).to have_http_status(404)
    end
  end
end