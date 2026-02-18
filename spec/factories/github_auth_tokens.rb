# frozen_string_literal: true

FactoryBot.define do
  factory :github_auth_token do
    token { 'test token' }
    expire_date { Time.current.since(1.day) }
  end
end