require "rails_helper"

RSpec.describe Api::V1::VariablesController, type: :controller do
  let(:repository) { create :repository }
  let!(:variable) { create :variable, repository: repository }

  describe "GET #index" do
    it "returns a list of variables" do
      get :index, params: { repository_id: repository.id }

      expect(response).to have_http_status(:ok)
      json_response = JSON.parse(response.body)
      expect(json_response['data'].map { |v| v['id'] }).to eq([ variable.id ])
    end
  end

  describe "POST #create" do
    let(:params) do
      {
        variable: {
          name: "Test variable",
          format: "test format",
          repository_id: repository.id,
          variable_type: variable_type,
          boolean_false_message: "Fail",
          boolean_success_message: "Success"
        }
      }
    end
    let(:variable_type) { "string" }

    subject { post :create, params: params }

    context "when success" do
      context "when variable type is string" do
        it "should return success message" do
          subject

          expect(response.status).to eq 201
          json_response = JSON.parse(response.body)
          expect(json_response['id']).to eq Variable.last.id
        end
      end

      context "when variable type is boolean" do
        let(:variable_type) { "boolean" }
        it "should return success message" do
          subject

          expect(response.status).to eq 201
          json_response = JSON.parse(response.body)
          expect(json_response['id']).to eq Variable.last.id
        end
      end
    end

    context "when fail" do
      it "should return unprocessible entity error" do
        params[:variable][:name] = nil

        subject

        expect(response.status).to eq 422
        json_response = JSON.parse(response.body)
        expect(json_response["errors"]).to eq [ "Name can't be blank" ]
      end
    end
  end

  describe "PUT #update" do
    let(:params) do
      {
        id: variable.id,
        variable: {
          name: "Updated variable",
          format: "updated format"
        }
      }
    end

    subject { put :update, params: params }

    context "when success" do
      it "should return success message" do
        subject

        expect(response.status).to eq 200
        json_response = JSON.parse(response.body)
        expect(json_response['id']).to eq variable.id
        expect(json_response['name']).to eq "Updated variable"
        expect(json_response['format']).to eq "updated format"
      end
    end

    context "when fail" do
      it "should return unprocessible entity error" do
        params[:variable][:name] = nil

        subject

        expect(response.status).to eq 422
        json_response = JSON.parse(response.body)
        expect(json_response["errors"]).to eq [ "Name can't be blank" ]
      end
    end
  end

  describe "DELETE #destroy" do
    subject { delete :destroy, params: { id: variable.id } }

    it "should return success message" do
      subject

      expect(response.status).to eq 200
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq "Variable deleted successfully"
    end
  end
end
