# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AjaxController, type: :controller do
  describe 'GET #counties' do
    let(:state) do
      State.create(name: 'Test State', symbol: 'TS', fips_code: '00', is_territory: false, lat_min: 0, lat_max: 0,
                   long_min: 0, long_max: 0)
    end

    before do
      get :counties, params: { state_symbol: state.symbol }
    end

    it 'returns http success' do
      expect(response).to have_http_status(:success)
    end

    it 'returns correct counties' do
      expect(JSON.parse(response.body)).to eq(state.counties.as_json)
    end
  end

  describe 'GET #counties with invalid state symbol' do
    before do
      get :counties, params: { state_symbol: 'InvalidSymbol' }
    end

    it 'returns http not found' do
      expect(response).to have_http_status(:not_found)
    end

    it 'returns an empty JSON array' do
      expect(JSON.parse(response.body)).to eq({ 'error' => 'State not found' })
    end
  end
end
