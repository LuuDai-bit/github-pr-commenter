# frozen_string_literal: true

require "rails_helper"

RSpec.describe GithubAuthToken, type: :model do
  let(:token) { build :github_auth_token }

  describe "validation" do
    it { should validate_presence_of(:token) }
    it { should validate_presence_of(:expire_date) }
  end

  describe "scope" do
    subject { GithubAuthToken.active_token }

    context "when there are 1 active token and 1 expired token" do
      let!(:active_token) { create(:github_auth_token) }
      let!(:expired_token) { create(:github_auth_token, expire_date: Time.current.ago(1.day)) }

      it "should return 1 active token" do
        tokens = subject

        expect(tokens.pluck(:id)).to eq [ active_token.id ]
      end
    end
  end
end
