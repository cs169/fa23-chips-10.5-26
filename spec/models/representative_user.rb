# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'find_google_user' do
    let(:google_user) { create(:user, first_name: 'Bob', last_name: 'Builder', provider: 'google_oauth2', uid: 1) }
    let(:github_user) { create(:user, first_name: 'Tris', last_name: 'Four', provider: 'github', uid: 2) }

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
      expect(result).to be_nil
    end
          
    it 'does not find an invalid Github user' do
      result = described_class.find_google_user(1)
      expect(result).to be_nil
    end
  end
end