# spec/controllers/events_controller_spec.rb
require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  describe 'GET #index' do
    context 'when no filter is applied' do
      it 'assigns all events to @events' do
        event1 = create(:event)
        event2 = create(:event)
        
        get :index

        expect(assigns(:events)).to match_array([event1, event2])
      end
    end

    context 'when filter-by is state-only' do
      let(:state) { create(:state) }
      let(:county1) { create(:county, state: state) }
      let(:county2) { create(:county, state: state) }
      let(:event1) { create(:event, county: county1) }
      let(:event2) { create(:event, county: county2) }

      before do
        get :index, params: { 'filter-by' => 'state-only', 'state' => state.symbol }
      end

      it 'assigns events filtered by state to @events' do
        expect(assigns(:events)).to match_array([event1, event2])
      end
    end

    context 'when filter-by is county-specific' do
      let(:state) { create(:state) }
      let(:county1) { create(:county, state: state) }
      let(:county2) { create(:county, state: state) }
      let(:event1) { create(:event, county: county1) }
      let(:event2) { create(:event, county: county2) }

      before do
        get :index, params: { 'filter-by' => 'county-specific', 'state' => state.symbol, 'county' => county1.fips_code }
      end

      it 'assigns events filtered by state and county to @events' do
        expect(assigns(:events)).to match_array([event1])
      end
    end
  end

  describe 'GET #show' do
    let(:event) { create(:event) }

    it 'assigns the requested event to @event' do
      get :show, params: { id: event.id }
      expect(assigns(:event)).to eq(event)
    end
  end
end
