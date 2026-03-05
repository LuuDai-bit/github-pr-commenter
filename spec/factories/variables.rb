# frozen_string_literal: true

FactoryBot.define do
  factory :variable do
    name { 'test variable' }
    variable_type { 'string' }
    format { 'test format' }

    repository
  end
end
