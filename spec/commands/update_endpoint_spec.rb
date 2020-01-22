# frozen_string_literal: true

require "spec_helper"

module Decidim::ComparativeStats::Admin
  describe UpdateEndpoint do
    let(:subject) { described_class.new(endpoint, form, user) }
    let(:organization) { create :organization }
    let(:endpoint) { create :endpoint, organization: organization }
    let(:user) { create(:user, :confirmed, :admin, organization: organization) }
    let(:form) do
      double(
        invalid?: invalid,
        endpoint: { endpoint: new_endpoint, active: true }
      )
    end

    let(:invalid) { false }

    let(:new_endpoint) { Faker::Internet.url }

    context "when the form is not valid" do
      let(:invalid) { true }

      it "is not valid" do
        expect { subject.call }.to broadcast(:invalid)
      end
    end

    context "when the form is valid" do
      before do
        subject.call
        endpoint.reload
      end

      it "updates the title of the endpoint" do
        expect(endpoint.endpoint).to eq(new_endpoint)
      end
    end
  end
end
