# frozen_string_literal: true

FactoryBot.define do
  factory :representative do
    name { 'Tim Kaine' }
    ocdid { 'ocd-division/country:us/state:va' }
    title { 'U.S. Senator' }
  end
end
