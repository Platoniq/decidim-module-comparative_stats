# frozen_string_literal: true

require "spec_helper"

module Decidim::ComparativeStats::Admin
  describe AggregatedMapsControlller, type: :controller do
    routes { Decidim::ComparativeStats::AdminEngine.routes }

    let(:user) { create(:user, :confirmed, :admin, organization: organization) }
    let(:organization) { create(:organization) }
    let(:url) { "http://example.com/api" }
    let(:endpoint) { create :endpoint, endpoint: url, organization: organization) }
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
  end
  
end