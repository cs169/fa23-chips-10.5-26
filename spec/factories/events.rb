# frozen_string_literal: true

FactoryBot.define do
  factory :event do
    name { 'Sample Event' }
    county { 'Sample County' }
    start_time { Time.current + 1.day }
    end_time { Time.current + 2.days }
  end
end
