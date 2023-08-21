# frozen_string_literal: true

require "spec_helper"
require "decidim/api/test/type_context"
require "decidim/core/test"

module Decidim::ComparativeStats
  describe "api queries" do
    include_context "with a graphql class type"
    let(:query) { File.open(File.join(__dir__, "../../lib/decidim/comparative_stats/queries", "#{tag}.graphql")).read }
    let(:type_class) { Decidim::Api::QueryType }
    let!(:current_user) { nil }

    before do
      allow(Decidim::Api::Schema).to receive(:max_complexity).and_return(5000)
    end

    describe "name_and_version" do
      let(:tag) { "name_and_version" }

      it "return expected data" do
        expect(response["decidim"].keys).to include("applicationName", "version")
      end
    end

    describe "participatory_processes" do
      let(:tag) { "participatory_processes" }
      let!(:participatory_processes) { create_list :participatory_process, 5, organization: current_organization }

      it "return expected data" do
        expect(response["participatoryProcesses"].first.keys).to include("id", "title", "startDate", "endDate")
      end
    end

    describe "global_metrics" do
      let(:tag) { "global_metrics" }
      let!(:metrics) { create(:metric, metric_type: "users", day: Time.current, cumulative: 1, quantity: 1, organization: current_organization) }

      it "return expected data" do
        expect(response["metrics"].first.keys).to include("count", "name")
      end
    end

    describe "global_history_metrics" do
      let(:tag) { "global_history_metrics" }
      let!(:metrics) { create(:metric, metric_type: "users", day: Time.current, cumulative: 1, quantity: 1, organization: current_organization) }

      it "return expected data" do
        expect(response["metrics"].first["history"].first.keys).to include("key", "value")
      end
    end

    describe "global_events" do
      let!(:assembly) { create(:assembly, organization: current_organization) }
      let(:tag) { "global_events" }

      context "when there are meetings" do
        let!(:component_meeting) { create(:component, manifest_name: :meetings, organization: current_organization, participatory_space: assembly) }
        let!(:meetings) { create_list(:meeting, 3, :published, component: component_meeting) }

        it "returns the corrent count of meetings" do
          expect(response["assemblies"].first["components"].first["meetings"]["edges"].count).to eq 3
        end

        it "returns the correct coordinates for all the meetings" do
          result = response["assemblies"].first["components"].first["meetings"]["edges"].map { |edges| edges["node"]["id"] }
          expect(result).to include(*meetings.map { |meeting| meeting.id.to_s })
        end
      end

      context "when there are proposals" do
        let!(:component_proposal) { create(:proposal_component, :with_geocoding_enabled, organization: current_organization, participatory_space: assembly) }
        let!(:proposals) { create_list(:proposal, 3, :published, component: component_proposal) }

        before do
          proposals.each do |proposal|
            proposal.latitude = Faker::Address.latitude
            proposal.longitude = Faker::Address.longitude
            proposal.save!
          end
        end

        it "returns expected data" do
          result = response["assemblies"].first["components"].first["proposals"]["edges"].map { |edges| edges["node"]["id"] }
          expect(result).to include(proposals.first.id.to_s)
          expect(result).to include(proposals.second.id.to_s)
          expect(result).to include(proposals.third.id.to_s)
        end
      end

      it "returns zero participatory_processes" do
        expect(response["participatoryProcesses"]).to eq []
      end
    end
  end
end
