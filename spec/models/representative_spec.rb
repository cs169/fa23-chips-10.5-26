# frozen_string_literal: true

require 'rails_helper'
require 'google/apis/civicinfo_v2'

describe Representative do
  describe '.civic_api_to_representative_params' do
    let(:offices) do
      instance_double(
        Google::Apis::CivicinfoV2::Office,
        name: 'Office1',
        division_id: 'Division1', official_indices: [0]
      )
    end
    let(:officials) do
      instance_double(Google::Apis::CivicinfoV2::Official,
                      name:      'Bobby Scott',
                      address:   nil,
                      party:     'Democrat',
                      photo_url: '')
    end

    let(:rep_info) do
      instance_double(
        Google::Apis::CivicinfoV2::RepresentativeInfoResponse,
        officials: [officials],
        offices:   [offices]
      )
    end

    it 'does not create duplicate representatives' do
      expect(described_class.count).to eq(0)
      described_class.civic_api_to_representative_params(rep_info)
      reps = described_class.civic_api_to_representative_params(rep_info)
      expect(reps.count).to eq(described_class.count)
    end
  end
end
