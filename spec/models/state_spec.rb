require 'rails_helper'

RSpec.describe State, type: :model do
  describe '#std_fips_code' do
    it 'returns a two-digit FIPS code' do
      state = create(:state, fips_code: 6) # Assuming you have a factory for the state model

      expect(state.std_fips_code).to eq('06')
    end

    it 'returns a two-digit FIPS code for single-digit input' do
      state = create(:state, fips_code: 1)

      expect(state.std_fips_code).to eq('01')
    end

    it 'returns a two-digit FIPS code for double-digit input' do
      state = create(:state, fips_code: 12)

      expect(state.std_fips_code).to eq('12')
    end
  end

  describe 'associations' do
    it 'has many counties' do
      state = create(:state) # Assuming you have a factory for the state model
      county1 = create(:county, state: state)
      county2 = create(:county, state: state)

      expect(state.counties).to match_array([county1, county2])
    end

    it 'deletes associated counties when destroyed' do
      state = create(:state) # Assuming you have a factory for the state model
      county = create(:county, state: state)

      expect { state.destroy }.to change { County.count }.by(-1)
    end
  end
end
