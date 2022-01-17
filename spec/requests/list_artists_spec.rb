require 'rails_helper'

RSpec.describe 'Artists', type: :request do
  # initialize test data
  # let!(:categories) { create_list(:category, 5) }
  # let!(:category_id) { categories.first.id }

  # Test suite for GET /category
  describe 'GET /api/v1/artists' do
    # make HTTP get request before each example
    before { get '/api/v1/artists' }
    it 'returns artists' do
      expect(json[0]['name']).to eq('BTS')
      expect(json[1]['name']).to eq('Arctic Monkeys')
      expect(json).not_to be_empty
      expect(json.size).to eq(2)
    end
    it 'returns status code 200' do
      expect(response).to have_http_status(200)
    end
  end
end