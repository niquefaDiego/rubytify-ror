require 'rails_helper'

RSpec.describe 'Get album songs', type: :request do
  fixtures :albums, :songs
  describe 'GET /api/v1/albums/:id/songs for valid album' do
    before { get '/api/v1/albums/6nYfHQnvkvOTNHnOhDT3sr/songs' }
    it 'returns songs' do
      expect(json['data']).not_to be_empty
      expect(json['data'][0]['name']).to eq('Life Goes On')
      expect(json['data'].size).to eq(1)
    end
    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /api/v1/albums/:id/songs for an invalid album' do
    before { get '/api/v1/albums/3nYxHQnvkvOTNHnOhDT3s2/songs' }
    it 'returns error message' do
      expect(json).not_to be_empty
      expect(json['message']).to eq('Album not found')
      expect(json.size).to eq(1)
    end
    it 'returns status code 404' do
      expect(response).to have_http_status(404)
    end
  end
end