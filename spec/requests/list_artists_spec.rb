require 'rails_helper'

RSpec.describe 'List artists', type: :request do
  describe 'GET /api/v1/artists' do
    before { get '/api/v1/artists' }
    it 'returns artists' do
      expect(json).not_to be_empty
      expect(json[0]['name']).to eq('BTS')
      expect(json[1]['name']).to eq('Arctic Monkeys')
      expect(json.size).to eq(2)
    end
    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end
end