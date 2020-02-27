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
      let!(:participatoryProcesses) { create_list :participatory_process, 5, organization: current_organization }

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
        let(:meetings) { create_list(:meeting, 3, :published, organization: current_organization, component: component_meeting) }
        # let!(:all_meetings) do
        #   create_list(:meeting, 3, component: component_meeting)
        # end

        it "returns the corrent count of meetigns" do
          expect(response["assemblies"][0]["components"][0]["meetings"]["edges"]). to be nil
        end

        it "returns the correct coordinates for all the meetings" do
          meetings = response["assemblies"]["components"]["meetings"].map { |meeting| meeting }
          expect(meetings).to include(*all_meetings.map(&[:latitude, :longitude]))
        end
      end

      context "when there are proposals" do
        let!(:component_proposal) { create(:component, manifest_name: :proposals, organization: current_organization, participatory_space: assembly) }
        let!(:proposals) { create_list(:proposal, 3, :published, organization: current_organization, component: component_proposal) }

        it "returns expected data" do
          expect(response). to be nil
        end
      end

      it "returns zero participatory_processes" do
        expect(response["participatoryProcesses"]). to eq []
      end
    end
  end
end
