# frozen_string_literal: true

require "spec_helper"

module Decidim::ComparativeStats::Admin
  describe GraphsController, type: :controller do
    routes { Decidim::ComparativeStats::AdminEngine.routes }

    let(:user) { create(:user, :confirmed, :admin, organization: organization) }
    let(:organization) { create(:organization) }

    before do
      request.env["decidim.current_organization"] = organization
      sign_in user
    end

    describe "GET show" do
      it "renders the default graph" do
        get :show, params: { graph: "global_stats" }
        expect(response).to have_http_status(:ok)
        expect(subject).to render_template(:show)
      end
    end
  end
end
