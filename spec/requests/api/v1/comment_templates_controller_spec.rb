require "rails_helper"

RSpec.describe Api::V1::CommentTemplatesController, type: :controller do
  let(:repository) { create :repository }
  let!(:comment_template) do
    create :comment_template, repository: repository, status: :draft
  end

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
          comment_template: {
            content: "New template",
            status: "active",
            repository_id: repository.id
          }
        }
      }.to change(CommentTemplate, :count).by(1)

      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)).to include({
        "content" => "New template",
        "status" => "active"
      })
    end
  end

  describe "PATCH #update" do
    it "updates an existing comment template for the repository" do
      patch :update, params: {
        id: comment_template.id,
        comment_template: {
          content: "Updated template",
          status: "draft",
          repository_id: repository.id
        }
      }

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include({
        "id" => comment_template.id,
        "content" => "Updated template",
        "status" => "draft"
      })
    end
  end

  describe "GET #show" do
    it "returns the details of a specific comment template" do
      get :show, params: { id: comment_template.id }

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['data']).to include({
        "id" => comment_template.id,
        "content" => comment_template.content,
        "status" => comment_template.status,
        "repository_id" => repository.id
      })
    end
  end

  describe "DELETE #destroy" do
    it "deletes a specific comment template" do
      expect {
        delete :destroy, params: { id: comment_template.id }
      }.to change(CommentTemplate, :count).by(-1)

      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)).to include({
        "message" => "Comment template deleted successfully"
      })
    end
  end

  describe "PATCH #make_active" do
    let!(:another_comment_template) do
      create :comment_template, repository: repository, status: :active
    end

    subject { patch :make_active, params: { id: comment_template.id } }

    context "when success" do
      it "should update comment template to active" do
        subject

        expect(another_comment_template.reload.status).to eq "draft"
        expect(comment_template.reload.status).to eq "active"
      end
    end
  end
end
