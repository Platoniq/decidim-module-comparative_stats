# frozen_string_literal: true

require "spec_helper"

module Decidim::ComparativeStats::Admin
  describe AggregatedMapsControlller, type: :controller do
    routes { Decidim::ComparativeStats::AdminEngine.routes }

    let(:user) { create(:user, :confirmed, :admin, organization: organization) }
    let(:organization) { create(:organization) }
    let(:url) { "http://example.com/api" }
    let(:endpoint) { create :endpoint, endpoint: url, organization: organization }
    let(:active) { true }
    let(:form) do
      {
        endpoint: endpoint.endpoint,
        name: "Test name",
        active: active
      }
    end
    let(:version) { "0.19.test" }
    let(:data) { { decidim: { applicationName: "Decidim Test", version: version } } }

    before do
      request.env["decidim.current_organization"] = organization
      sign_in user
    end

    describe "GET #index" do
      it "renders the index" do
        get :index

        expect(response).to have_http_status(:ok)
        expect(subject).to render_template(:index)
      end
    end
  end
end
