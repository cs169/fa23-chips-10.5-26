# frozen_string_literal: true

require 'rails_helper'
require 'spec_helper'

RSpec.describe MapController, type: :controller do
  state_symbol = 'VA'
  county_fips_code = '051'
  it 'searches by county successfully' do
    expect(response.status).to eq(200)
    get :county, params: { state_symbol: state_symbol, std_fips_code: county_fips_code }
  end
end
