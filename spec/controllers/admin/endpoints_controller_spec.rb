# frozen_string_literal: true

require "spec_helper"

module Decidim::ComparativeStats::Admin
  describe EndpointsController do
    routes { Decidim::ComparativeStats::AdminEngine.routes }

    let(:user) { create(:user, :confirmed, :admin, organization:) }
    let(:organization) { create(:organization) }
    let(:url) { "http://example.com/api" }
    let(:endpoint) { create(:endpoint, endpoint: url, organization:) }
    let(:active) { true }
    let(:form) do
      {
        endpoint: endpoint.endpoint,
        name: "Test name",
        active:
      }
    end
    let(:version) { "0.19.test" }
    let(:data) { { decidim: { applicationName: "Decidim test", version: } } }

    before do
      request.env["decidim.current_organization"] = organization
      sign_in user

      controller.params["endpoint"] = form
      controller.api.client = Graphlient::Client.new(url, schema_path: "#{__dir__}/../../lib/schema.json")
      stub_request(:post, url)
        .to_return(status: 200, body: "{\"data\":#{data.to_json}}", headers: {})
    end

    describe "organization_endpoints" do
      let!(:inactive_endpoint) { create(:endpoint, active: false, organization:) }

      it "returns all endpoints" do
        expect(controller.organization_endpoints).to include(endpoint)
        expect(controller.organization_endpoints).to include(inactive_endpoint)
      end
    end

    describe "GET #index" do
      it "renders the index listing" do
        get :index
        expect(response).to have_http_status(:ok)
        expect(subject).to render_template(:index)
      end
    end

    describe "GET #new" do
      it "renders the empty form" do
        get :new
        expect(response).to have_http_status(:ok)
        expect(subject).to render_template(:new)
      end
    end

    describe "POST #create" do
      context "when there is permission" do
        it "returns ok" do
          post :create, params: { endpoint: form }
          expect(flash[:notice]).not_to be_empty
          expect(response).to have_http_status(:found)
        end

        it "creates the new endpoint" do
          post :create, params: { endpoint: form }
          expect(Decidim::ComparativeStats::Endpoint.first.name).to eq(endpoint.name)
        end
      end

      context "when api version is less than required" do
        let(:version) { "0.17" }

        it "returns error" do
          post :create, params: { endpoint: form }
          expect(flash[:alert]).not_to be_empty
          expect(subject).to render_template(:new)
        end
      end
    end

    describe "GET edit" do
      let(:endpoint) { create(:endpoint, name: "Some name", endpoint: url, organization:) }

      it "renders the edit form" do
        get :edit, params: { id: endpoint.id }
        expect(response).to have_http_status(:ok)
        expect(subject).to render_template(:edit)
      end
    end

    describe "PATCH #update" do
      context "when there is permission" do
        let(:endpoint) { create(:endpoint, name: "Some name", endpoint: url, organization:) }

        it "returns ok" do
          patch :update, params: { id: endpoint.id, endpoint: form }
          expect(flash[:notice]).not_to be_empty
          expect(response).to have_http_status(:found)
        end

        it "creates the new endpoint" do
          patch :update, params: { id: endpoint.id, endpoint: form }
          expect(Decidim::ComparativeStats::Endpoint.first.name).to eq(form[:name])
        end
      end

      context "when api version is less than required" do
        let(:version) { "0.17" }

        it "returns error" do
          patch :update, params: { id: endpoint.id, endpoint: form }
          expect(flash[:alert]).not_to be_empty
          expect(subject).to render_template(:edit)
        end
      end
    end

    describe "DELETE #destroy" do
      let(:endpoint) { create(:endpoint, organization:) }

      it "destroys the endpoint" do
        delete :destroy, params: { id: endpoint.id }

        expect(flash[:notice]).not_to be_empty
        expect(response).to have_http_status(:found)
      end
    end
  end
end
