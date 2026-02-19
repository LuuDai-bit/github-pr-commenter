require "rails_helper"

RSpec.describe Api::V1::CommentTemplatesController, type: :controller do
  let(:repository) { create :repository }
  let!(:comment_template) { create :comment_template, repository: repository }

  describe "GET #index" do
    it "returns a list of comment templates for the repository" do
      get :index, params: { repository_id: repository.id }

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['data'].map { |r| r['id'] }).to eq([ comment_template.id ])
    end
  end

  describe "POST #create" do
    it "creates a new comment template for the repository" do
      expect {
        post :create, params: {
          repository_id: repository.id,
          comment_template: {
            content: "New template",
            status: "active"
          }
        }
      }.to change(CommentTemplate, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)).to include({
        "content" => "New template",
        "status" => "active",
        "repository_id" => repository.id
      })
    end
  end

  describe "PATCH #update" do
    it "updates an existing comment template for the repository" do
      patch :update, params: {
        repository_id: repository.id,
        id: comment_template.id,
        comment_template: {
          content: "Updated template",
          status: "draft"
        }
      }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include({
        "id" => comment_template.id,
        "content" => "Updated template",
        "status" => "draft",
        "repository_id" => repository.id
      })
    end
  end
end
