# frozen_string_literal: true

require "spec_helper"
require "decidim/api/test/type_context"

module Decidim::ComparativeStats
  describe ApiFetcher do
    include_context "with a graphql type"
    let(:type_class) { Decidim::Api::QueryType }
    let!(:current_user) { nil }

    describe "name_and_version" do
      let(:query) { ApiQueries::NAME_AND_VERSION }

      it "return expected data" do
        expect(response["decidim"].keys).to include("applicationName", "version")
      end
    end

    describe "participatory_processes" do
      let(:query) { ApiQueries::PARTICIPATORY_PROCESSES }
      let!(:participatoryProcesses) { create_list :participatory_process, 5, organization: current_organization }

      it "return expected data" do
        expect(response["participatoryProcesses"].first.keys).to include("id", "title", "startDate", "endDate")
      end
    end

    describe "global_metrics" do
      let(:query) { ApiQueries::GLOBAL_METRICS }
      let!(:metrics) { create(:metric, metric_type: "users", day: Time.current, cumulative: 1, quantity: 1, organization: current_organization) }

      it "return expected data" do
        expect(response["metrics"].first.keys).to include("count", "name")
      end
    end

    describe "global_history_metrics" do
      let(:query) { ApiQueries::GLOBAL_HISTORY_METRICS }
      let!(:metrics) { create(:metric, metric_type: "users", day: Time.current, cumulative: 1, quantity: 1, organization: current_organization) }

      it "return expected data" do
        expect(response["metrics"].first["history"].first.keys).to include("key", "value")
      end
    end
  end
end
