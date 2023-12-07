# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:first_name) { |n| "Jane#{n}" }
    sequence(:last_name) { |n| "Smith#{n}" }
    sequence(:uid) { |n| "uid#{n}" }
    provider { 'google_oauth2' }
  end
end
