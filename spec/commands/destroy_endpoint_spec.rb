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

      it "traces the action", versioning: true do
        expect(Decidim.traceability)
          .to receive(:perform_action!)
          .with(
            "delete",
            endpoint,
            user
          )
          .and_call_original

        expect { subject.call }.to change(Decidim::ActionLog, :count)
        action_log = Decidim::ActionLog.last
        expect(action_log.version).to be_present
      end
    end
  end
end
