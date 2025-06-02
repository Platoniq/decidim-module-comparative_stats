# frozen_string_literal: true

require "spec_helper"

module Decidim::ComparativeStats
  describe ApplicationHelper do
    before do
      allow(helper).to receive(:current_organization).and_return(organization)
    end

    let(:organization) { create(:organization) }
    let!(:active_endpoint) { create(:endpoint, active: true, organization:) }
    let!(:inactive_endpoint) { create(:endpoint, active: false, organization:) }

    describe "active_endpoint" do
      it "returns active endpoints only" do
        expect(helper.active_endpoints).to include(active_endpoint)
        expect(helper.active_endpoints).not_to include(inactive_endpoint)
      end
    end
  end
end
