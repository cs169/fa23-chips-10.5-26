# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NewsItem, type: :model do
  describe '#find_for' do
    let(:representative) { create(:representative) }
    let(:news_item) { create(:news_item, representative: representative) }

    it 'finds a news item for a representative' do
      found_news_item = described_class.find_for(representative.id)
      expect(found_news_item).to eq(news_item)
    end

    it 'returns nil if no news item is found' do
      found_news_item = described_class.find_for(999)
      expect(found_news_item).to be_nil
    end
  end
end