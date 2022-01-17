require 'rails_helper'

RSpec.describe 'Get artist album', type: :request do
  describe 'GET /api/v1/artists/:id/albums for valid artist' do
    before { get '/api/v1/artists/3Nrfpe0tUJi4K4DXYWgMUX/albums' }
    it 'returns albums' do
      expect(json).not_to be_empty
      expect(json.size).to eq(2)
    end
    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end

  describe 'GET /api/v1/artists/:id/albums for an invalid artist' do
    before { get '/api/v1/artists/3nYxHQnvkvOTNHnOhDT3s2/albums' }
    it 'returns error message' do
      expect(json).not_to be_empty
      expect(json['message']).to eq('Artist not found')
      expect(json.size).to eq(1)
    end
    it 'returns status code 404' do
      expect(response).to have_http_status(404)
    end
  end
end