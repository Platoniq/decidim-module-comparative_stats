# frozen_string_literal: true

require "spec_helper"

module Decidim::ComparativeStats
  describe WidgetsController, type: :controller do
    routes { Decidim::ComparativeStats::Engine.routes }

    let(:organization) { create(:organization) }

    before do
      request.env["decidim.current_organization"] = organization
    end

    describe "GET show" do
      it "renders the all tabs widgets" do
        get :show, params: { graph: :all }
        expect(response).to have_http_status(:ok)
        expect(subject).to render_template(:all)
      end

      it "renders the global_stats widgets" do
        get :show, params: { graph: :global_stats }
        expect(response).to have_http_status(:ok)
        expect(subject).to render_template(:global_stats)
      end

      it "renders the global_stats_timeline widgets" do
        get :show, params: { graph: :global_stats_timeline }
        expect(response).to have_http_status(:ok)
        expect(subject).to render_template(:global_stats_timeline)
      end
    end
  end
end
