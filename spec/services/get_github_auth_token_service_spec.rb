require "rails_helper"

RSpec.describe GetGithubAuthTokenService, type: :service do
  describe "#run" do
    let(:owner) { "LuuDai-bit" }
    let(:repo) { "blog" }
    subject { described_class.new(owner, repo).run }

    context "when success" do
      before do
        allow(File).to receive(:exist?).and_return true
        allow(File).to receive(:read).and_return "private_key_content"
        allow(OpenSSL::PKey::RSA).to receive(:new).and_return "private_key"
        allow(JWT).to receive(:encode).and_return "jwt_token"
        allow(HTTParty).to receive(:get).and_return({ "id" => 123 })
        allow(HTTParty).to receive(:post).and_return({ "token" => "access_token", "expires_at" => Time.now + 10.minutes })
      end

      it "should return access token" do
        expect(subject).to eq "access_token"
      end

      it "should create GithubAuthToken record" do
        expect { subject }.to change(GithubAuthToken, :count).by(1)
      end
    end

    context "when file not found" do
      before do
        allow(File).to receive(:exist?).and_return false
      end

      it "should raise FileNotFound error" do
        expect { subject }.to raise_error(GetGithubAuthTokenService::FileNotFound)
      end
    end

    context "when fetch error" do
      before do
        allow(File).to receive(:exist?).and_return true
        allow(File).to receive(:read).and_return "private_key_content"
        allow(OpenSSL::PKey::RSA).to receive(:new).and_return "private_key"
        allow(JWT).to receive(:encode).and_return "jwt_token"
        allow(HTTParty).to receive(:get).and_return({ "id" => 123 })
        allow(HTTParty).to receive(:post).and_return({})
      end

      it "should raise FetchError error" do
        expect { subject }.to raise_error(GetGithubAuthTokenService::FetchError)
      end
    end
  end
end
