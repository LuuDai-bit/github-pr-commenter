# frozen_string_literal: true

require "rails_helper"

RSpec.describe Variable, type: :model do
  describe "validations" do
    it { should validate_presence_of(:name) }
  end

  describe "associations" do
    it { should belong_to(:repository) }
  end
end