# frozen_string_literal: true

require "spec_helper"

module Decidim::ComparativeStats::Admin
  describe CreateEndpoint do
    let(:subject) { described_class.new(form) }
    let(:form) do
      double(
        # EndpointForm,
        endpoint: endpoint,
        active: true,
        current_organization: organization,
        current_user: user,
        invalid?: invalid,
        context: double(api: api)
      )
    end

    let(:name_and_version) do
      double(
        application_name: "Test Decidim API",
        version: version
      )
    end
    let(:version) { Decidim::ComparativeStats::MIN_API_VERSION }

    let(:organization) { create :organization }
    let(:api) do
      double(
        name_and_version: name_and_version
      )
    end
    let(:endpoint) { Faker::Internet.url }
    let(:user) { create :user, :admin, :confirmed, organization: organization }

    let(:invalid) { false }

    context "when the form is not valid" do
      let(:invalid) { true }

      it "is not valid" do
        expect { subject.call }.to broadcast(:invalid)
      end
    end

    context "when the form is valid" do
      it "broadcasts ok" do
        expect { subject.call }.to broadcast(:ok)
      end

      it "creates a new endpoint for the organization" do
        expect { subject.call }.to change { Decidim::ComparativeStats::Endpoint.count }.by(1)
      end

      it "traces the action", versioning: true do
        expect(Decidim.traceability)
          .to receive(:create!)
          .with(Decidim::ComparativeStats::Endpoint, user, hash_including(:endpoint, :name, :api_version))
          .and_call_original

        expect { subject.call }.to change(Decidim::ActionLog, :count)
        action_log = Decidim::ActionLog.last
        expect(action_log.version).to be_present
      end
    end
  end
end
