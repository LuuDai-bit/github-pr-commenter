# frozen_string_literal: true

FactoryBot.define do
  factory :comment_template do
    content { FFaker::Lorem.sentence }
    status { %w[active draft].sample }

    repository
  end
end
