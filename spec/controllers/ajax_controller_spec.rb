# spec/controllers/ajax_controller_spec.rb
require 'rails_helper'

RSpec.describe AjaxController, type: :controller do
  describe 'GET #counties' do
    let(:state) { create(:state, symbol: 'CA') } # Assuming you have a factory for state creation

    context 'when state_symbol is provided' do
      it 'finds the state by symbol' do
        get :counties, params: { state_symbol: 'CA' }
        expect(assigns(:state)).to eq(state)
      end

      it 'renders JSON with state counties' do
        county1 = create(:county, state: state)
        county2 = create(:county, state: state)

        get :counties, params: { state_symbol: 'CA' }

        expected_response = JSON.parse([county1, county2].to_json)
        expect(response.body).to eq(expected_response.to_json)
      end

      it 'returns a successful response' do
        get :counties, params: { state_symbol: 'CA' }
        expect(response).to have_http_status(:success)
      end
    end

    context 'when state_symbol is not provided' do
      it 'returns a bad request status' do
        get :counties
        expect(response).to have_http_status(:bad_request)
      end

      it 'does not assign @state' do
        get :counties
        expect(assigns(:state)).to be_nil
      end
    end
  end
end
