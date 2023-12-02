require 'rails_helper'
require 'spec_helper'

# frozen_string_literal: true
RSpec.describe User, type: :model do
  describe 'find_google_user' do
    let!(:google_user) { create(:user, first_name: 'Bob', last_name: 'Builder', provider: 'google_oauth2') }
    let!(:github_user) { create(:user, first_name: 'Tris', last_name: 'Four', provider: 'github') }

    it 'finds a valid Google user' do
      result = described_class.find_google_user(1)
      expect(result.name).to eq 'Bob Builder'
    end
    
    it 'finds a valid Github user' do
      result = described_class.find_github_user(2)
      expect(result.name).to eq 'Tris Four'
    end
    
    it 'does not find an invalid Google user' do
      result = described_class.find_google_user(2)
      expect(result.name).to be_nil
    end
          
    it 'does not find an invalid Github user' do
      result = described_class.find_google_user(1)
      expect(result).to be_nil
    end

  end
end