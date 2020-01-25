# frozen_string_literal: true

require "spec_helper"

module Decidim::ComparativeStats::Admin
  describe UpdateEndpoint do
    let(:subject) { described_class.new(endpoint, form, user) }
    let(:organization) { create :organization }
    let(:endpoint) { create :endpoint, active: false, organization: organization }
    let(:user) { create(:user, :confirmed, :admin, organization: organization) }
    let(:form) do
      double(
        invalid?: invalid,
        endpoint: Faker::Internet.url,
        name: Faker::Name.name,
        active: true
      )
    end
    let(:invalid) { false }

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
        expect(endpoint.endpoint).to eq(endpoint.endpoint)
      end

      it "traces the action", versioning: true do
        expect(Decidim.traceability)
          .to receive(:update!)
          .with(endpoint, user, endpoint: form.endpoint, name: form.name, active: form.active)
          .and_call_original

        expect { subject.call }.to change(Decidim::ActionLog, :count)
        action_log = Decidim::ActionLog.last
        expect(action_log.version).to be_present
      end
    end
  end
end
