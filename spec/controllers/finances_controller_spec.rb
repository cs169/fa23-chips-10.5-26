# frozen_string_literal: true

require 'rails_helper'

RSpec.describe FinancesController, type: :controller do
  describe 'GET #search_finances' do
    let(:cycle) { '2022' }
    let(:category) { 'something' }

    it 'calls the ProPublica API with the correct parameters' do
      connection = class_double(Faraday)
      allow(connection).to receive(:url_prefix=)
      get :search_finances, params: { cycle: cycle, category: category }

      expect(response).to render_template('finances/show')
    end
  end
end
