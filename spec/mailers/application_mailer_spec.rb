# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ApplicationRecord, type: :model do
  it 'is an abstract class' do
    expect(ApplicationRecord.abstract_class).to be_truthy
  end
end
