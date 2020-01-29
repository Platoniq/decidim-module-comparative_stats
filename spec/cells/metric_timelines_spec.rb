# frozen_string_literal: true

require "spec_helper"

module Decidim::ComparativeStats
  describe MetricTimelinesCell, type: :cell do
    controller Decidim::ApplicationController

    subject { cell("decidim/comparative_stats/metric_timelines", model).call }

    let(:model) do
      [double(
        api: double(fetch_global_history_metrics: api_call),
        name: "Example endpoint"
      )]
    end

    let(:api_call) do
      double(data: double(metrics: [users]))
    end

    let(:users) do
      double(name: "users", history: [double(key: "2020-01-01", value: 4)])
    end

    it "renders the cell" do
      expect(subject).to have_css("#line_chart_users")
    end
  end
end
