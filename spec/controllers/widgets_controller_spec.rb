# frozen_string_literal: true

require "spec_helper"

module Decidim::ComparativeStats
  describe WidgetsController do
    routes { Decidim::ComparativeStats::Engine.routes }

    let(:organization) { create(:organization) }

    before do
      request.env["decidim.current_organization"] = organization
    end

    describe "GET show" do
      it "renders the all tabs widgets" do
        get :show, params: { graph: :all }
        expect(response).to have_http_status(:ok)
        expect(subject).to render_template(:show)
      end

      it "does not render non existing widgets" do
        get :show, params: { graph: :non_existing }
        expect(response).to have_http_status(:not_found)
      end

      it "renders the global_stats widgets" do
        get :show, params: { graph: :global_stats }
        expect(response).to have_http_status(:ok)
        expect(subject).to render_template(:show)
      end

      it "renders the global_stats_timeline widgets" do
        get :show, params: { graph: :global_stats_timeline }
        expect(response).to have_http_status(:ok)
        expect(subject).to render_template(:show)
      end

      it "renders the processes_timeline widgets" do
        get :show, params: { graph: :processes_timeline }
        expect(response).to have_http_status(:ok)
        expect(subject).to render_template(:show)
      end

      it "renders the spaces_geocoded_events widgets" do
        get :show, params: { graph: :spaces_geocoded_events }
        expect(response).to have_http_status(:ok)
        expect(subject).to render_template(:show)
      end
    end
  end
end
