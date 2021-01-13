# frozen_string_literal: true

require "spec_helper"
require "decidim/api/test/type_context"
require "decidim/core/test"

module Decidim::ComparativeStats
  describe ApiQueries do
    include_context "with a graphql type"
    let(:subject) { described_class }
    let(:type_class) { Decidim::Api::QueryType }
    let!(:current_user) { nil }

    describe "name_and_version" do
      let(:query) { subject::NAME_AND_VERSION }

      it "return expected data" do
        expect(response["decidim"].keys).to include("applicationName", "version")
      end
    end

    describe "participatory_processes" do
      let(:query) { subject::PARTICIPATORY_PROCESSES }
      let!(:participatory_processes) { create_list :participatory_process, 5, organization: current_organization }

      it "return expected data" do
        expect(response["participatoryProcesses"].first.keys).to include("id", "title", "startDate", "endDate")
      end
    end

    describe "global_metrics" do
      let(:query) { subject::GLOBAL_METRICS }
      let!(:metrics) { create(:metric, metric_type: "users", day: Time.current, cumulative: 1, quantity: 1, organization: current_organization) }

      it "return expected data" do
        expect(response["metrics"].first.keys).to include("count", "name")
      end
    end

    describe "global_history_metrics" do
      let(:query) { subject::GLOBAL_HISTORY_METRICS }
      let!(:metrics) { create(:metric, metric_type: "users", day: Time.current, cumulative: 1, quantity: 1, organization: current_organization) }

      it "return expected data" do
        expect(response["metrics"].first["history"].first.keys).to include("key", "value")
      end
    end

    describe "global_events" do
      let(:query) { subject::GLOBAL_EVENTS }
      let!(:assembly) { create(:assembly, organization: current_organization) }

      context "when there are meetings" do
        let!(:component_meeting) { create(:component, manifest_name: :meetings, organization: current_organization, participatory_space: assembly) }
        let!(:meetings) { create_list(:meeting, 3, component: component_meeting) }

        it "returns the corrent count of meetigns" do
          expect(response["assemblies"].first["components"].first["meetings"]["edges"].count). to eq 3
        end

        it "returns the correct coordinates for all the meetings" do
          # result = response["assemblies"].first["components"].first["meetings"]["edges"].map { |meeting| meeting.edges.node }
          result = response["assemblies"].first["components"].first["meetings"]["edges"].map { |edges| edges["node"]["id"] }
          expect(result).to include(*meetings.map { |meeting| meeting.id.to_s })
        end
      end

      context "when there are proposals" do
        let!(:component_proposal) { create(:proposal_component, :with_geocoding_enabled, organization: current_organization, participatory_space: assembly) }
        let!(:proposals) { create_list(:proposal, 3, :published, component: component_proposal) }

        before do
          proposals.first.latitude = Faker::Address.latitude
          proposals.first.longitude = Faker::Address.longitude
          proposals.first.save!

          proposals.second.latitude = Faker::Address.latitude
          proposals.second.longitude = Faker::Address.longitude
          proposals.second.save!

          proposals.third.latitude = Faker::Address.latitude
          proposals.third.longitude = Faker::Address.longitude
          proposals.third.save!
        end

        it "returns expected data" do
          result = response["assemblies"].first["components"].first["proposals"]["edges"].map { |edges| edges["node"]["id"] }
          expect(result).to include(proposals.first.id.to_s)
          expect(result).to include(proposals.second.id.to_s)
          expect(result).to include(proposals.third.id.to_s)
        end
      end

      it "returns zero participatory_processes" do
        expect(response["participatoryProcesses"]). to eq []
      end
    end
  end
end
