# frozen_string_literal: true

require "spec_helper"

module Decidim::ComparativeStats::Admin
  describe EndpointsController, type: :controller do
    routes { Decidim::ComparativeStats::AdminEngine.routes }

    let(:user) { create(:user, :confirmed, :admin, organization: organization) }
    let(:organization) { create(:organization) }

    before do
      request.env["decidim.current_organization"] = organization
      sign_in user
    end

    describe "GET index" do
      it "renders the index listing" do
        get :index
        expect(response).to have_http_status(:ok)
        expect(subject).to render_template(:index)
      end
    end

    describe "GET new" do
      it "renders the empty form" do
        get :new
        expect(response).to have_http_status(:ok)
        expect(subject).to render_template(:new)
      end
    end

    describe "POST create" do
      context "when there is permission" do
        let(:endpoint) { create :endpoint, organization: organization }
        let(:active) { true }

        it "returns ok" do
          post :create, params: { endpoint: endpoint, active: active }
          expect(response).to broadcast(:ok)
        end
      end
    end
  end
end
