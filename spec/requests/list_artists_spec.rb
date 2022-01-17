require 'rails_helper'

RSpec.describe 'List artists', type: :request do
  fixtures :artists

  describe 'GET /api/v1/artists' do
    before { get '/api/v1/artists' }
    it 'returns artists' do
      expect(json['data']).not_to be_empty
      expect(json['data'][0]['name']).to eq('BTS')
      expect(json['data'][1]['name']).to eq('Arctic Monkeys')
      expect(json['data'].size).to eq(2)
    end
    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end
end