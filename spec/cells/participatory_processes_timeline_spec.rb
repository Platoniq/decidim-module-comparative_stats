# frozen_string_literal: true

require "spec_helper"

module Decidim::ComparativeStats
  describe ParticipatoryProcessesTimelineCell, type: :cell do
    controller Decidim::ApplicationController

    subject { cell("decidim/comparative_stats/participatory_processes_timeline", model).call }

    let(:model) do
      [double(
        api: double(fetch_participatory_processes: api_call),
        name: "Example endpoint"
      )]
    end

    let(:api_call) do
      double(data: double(participatory_processes: [process]))
    end

    let(:process) do
      double(
        title: double(translations: [double(text: "Title")]),
        start_date: "2020-01-01",
        end_date: "2020-01-01"
      )
    end

    it "renders the cell" do
      expect(subject).to have_css("#participatoryProcessesChart")
    end
  end
end
