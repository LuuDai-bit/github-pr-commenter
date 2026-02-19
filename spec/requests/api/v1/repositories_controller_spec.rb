require "rails_helper"

RSpec.describe Api::V1::RepositoriesController, type: :controller do
  let!(:repository) { create :repository }

  describe "GET #index" do
    it "returns a list of repositories" do
      get :index

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['data'].map { |r| r['id'] }).to eq([repository.id])
    end
  end

  describe "POST #create" do
    let(:params) do
      {
        repository: {
          owner: "Test owner",
          name: "Test repo"
        }
      }
    end

    subject { post :create, params: params }

    context "when success" do
      it "should return success message" do
        subject

        expect(response.status).to eq 201
        json_response = JSON.parse(response.body)
        expect(json_response['id']).to eq Repository.last.id
      end
    end

    context "when fail" do
      it "should return unprocessible entity error" do
        params[:repository][:name] = nil

        subject

        expect(response.status).to eq 422
        json_response = JSON.parse(response.body)
        expect(json_response["errors"]).to eq ["Name can't be blank"]
      end
    end
  end
end
