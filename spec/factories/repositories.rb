# frozen_string_literal: true

FactoryBot.define do
  factory :repository do
    owner { 'test owner' }
    name { 'test repo' }
  end
end
