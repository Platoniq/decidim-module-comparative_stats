# frozen_string_literal: true

require "spec_helper"

module Decidim::ComparativeStats
  describe ParticipatorySpacesGeocodedEventsCell, type: :cell do
    controller Decidim::ApplicationController

    subject { cell("decidim/comparative_stats/participatory_spaces_geocoded_events", model).call }

    let(:model) do
      [double(
        api: double(fetch_global_events: api_call),
        name: "Example endpoint"
      )]
    end

    let(:api_call) do
      double(data: double(events: [events]))
    end

    let(:events) do
      double(
        name: "endpoint"
      )
    end

    it "renders the cell" do
      expect(subject).to have_css("#geocoded_events")
    end
  end
end
