# frozen_string_literal: true

require "spec_helper"

module Decidim::ComparativeStats::Admin
  describe EndpointForm do
    subject { described_class.from_params(attributes).with_context(api: api) }

    let(:name) { Faker::Name.name }
    let(:endpoint) { Faker::Internet.url }
    let(:attributes) do
      {
        name: name,
        endpoint: endpoint,
        active: true
      }
    end
    let(:api_valid) { true }
    let(:api) do
      double(
        valid?: api_valid,
        error: "version error"
      )
    end

    context "when everything is OK" do
      it { is_expected.to be_valid }
    end

    context "when api version is lower than required" do
      let(:api_valid) { false }

      it { is_expected.to be_invalid }
    end
  end
end
