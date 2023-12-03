# frozen_string_literal: true

require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'find_google_user' do
    let(:google_user) do
      described_class.create(uid: '1', first_name: 'Bob', last_name: 'Builder', provider: 'google_oauth2')
    end
    let(:github_user) { described_class.create(uid: '2', first_name: 'Tris', last_name: 'Four', provider: 'github') }

    it 'the first and last name are name' do
      expect(google_user.name).to eq 'Bob Builder'
    end

    it 'does not find an invalid Google user' do
      result = described_class.find_google_user('2')
      expect(result).to be_nil
    end
  end

  describe 'find_github_user' do
    let(:google_user) do
      described_class.create(uid: '1', first_name: 'Bob', last_name: 'Builder', provider: 'google_oauth2')
    end
    let(:github_user) { described_class.create(uid: '2', first_name: 'Tris', last_name: 'Four', provider: 'github') }

    it 'does not find an invalid Github user' do
      result = described_class.find_github_user('1')
      expect(result).to be_nil
    end
  end
end
