require "rails_helper"

RSpec.describe Api::V1::CommentsController, type: :controller do
  describe "POST #create" do
    let(:params) do
      {
        project_coverage: 80,
        patch_coverage: 90
      }
    end

    subject { post :create, params: params }

    context "when success" do
      before do
        allow(GetGithubAuthTokenService).to receive(:run).and_return "token"
        allow(SendCommentJob).to receive(:perform_async).and_return "jid"
      end

      context "without active github auth token" do
        it "should return success message" do
          subject

          json_response = JSON.parse(response.body)
          expect(json_response["message"]).to eq "The comment has been queued"
        end
      end

      context "with valid github auth token" do
        let!(:github_auth_token) { create :github_auth_token }

        it "should return success message" do
          subject

          json_response = JSON.parse(response.body)
          expect(json_response["message"]).to eq "The comment has been queued"
        end
      end

      it "should return 200 status code" do
        subject

        expect(response.status).to eq 200
      end
    end
  end
end
