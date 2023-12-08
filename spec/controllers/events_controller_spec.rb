# frozen_string_literal: true

require 'rails_helper'

RSpec.describe EventsController, type: :controller do
  describe '#index' do
    it 'assigns all events when no filter is applied' do
      events = instance_double(Event)
      allow(Event).to receive(:all).and_return(events)

      get :index

      expect(assigns(:events)).to eq(events)
    end

    it 'renders the index template' do
      get :index
      expect(response).to render_template('index')
    end
  end

  describe '#show' do
    it 'assigns the requested event' do
      event = instance_double(Event)
      allow(Event).to receive(:find).and_return(event)

      get :show, params: { id: 1 }

      expect(assigns(:event)).to eq(event)
    end

    it 'renders the show template' do
      event = instance_double(Event)
      allow(Event).to receive(:find).and_return(event)

      get :show, params: { id: 1 }

      expect(response).to render_template('show')
    end
  end
end
