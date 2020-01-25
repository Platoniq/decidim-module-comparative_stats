# frozen_string_literal: true

require "spec_helper"

module Decidim::ComparativeStats::Admin
  describe DestroyEndpoint do
    let(:subject) { described_class.new(endpoint, user) }
    let(:organization) { create :organization }
    let(:endpoint) { create :endpoint, organization: organization }
    let(:user) { create(:user, :confirmed, :admin, organization: organization) }

    context "when everything is ok" do
      it "destroys the endpoint" do
        subject.call
        expect { endpoint.reload }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
