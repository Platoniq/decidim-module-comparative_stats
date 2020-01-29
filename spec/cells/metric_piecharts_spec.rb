# frozen_string_literal: true

require "spec_helper"

module Decidim::ComparativeStats
  describe MetricPiechartsCell, type: :cell do
    controller Decidim::ApplicationController

    subject { cell("decidim/comparative_stats/metric_piecharts", model).call }

    let(:model) do
      [double(
        api: double(fetch_global_metrics: api_call),
        name: "Example endpoint"
      )]
    end

    let(:api_call) do
      double(data: double(metrics: [users]))
    end

    let(:users) do
      double(name: "users", count: 5)
    end

    it "renders the cell" do
      expect(subject).to have_css("#pie_chart_users")
    end
  end
end
