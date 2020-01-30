# frozen_string_literal: true

require "spec_helper"

module Decidim::ComparativeStats
  describe Endpoint do
    subject { endpoint }

    let(:organization) { create(:organization) }
    let(:endpoint) { create(:endpoint, organization: organization) }

    it { is_expected.to be_valid }

    it "endpoint is associated with organization" do
      expect(subject).to eq(endpoint)
      expect(subject.organization).to eq(organization)
      expect(subject.api_version).to eq(Decidim::ComparativeStats::MIN_API_VERSION)
    end
  end
end
