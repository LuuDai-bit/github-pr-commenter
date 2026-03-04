# frozen_string_literal: true

FactoryBot.define do
  factory :variable do
    name { 'test variable' }
    format { 'test format' }

    repository
  end
end
