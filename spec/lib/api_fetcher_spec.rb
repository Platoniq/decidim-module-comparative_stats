# frozen_string_literal: true

require "graphlient"
require "spec_helper"

module Decidim::ComparativeStats
  describe ApiFetcher do
    let(:subject) { described_class.new(url) }
    let(:url) { "http://example.com/api" }

    context "when client is not assigned" do
      before do
        stub_request(:post, url).to_return(
          status: 200,
          body: Decidim::Api::Schema.execute(GraphQL::Introspection::INTROSPECTION_QUERY).to_json
        )
      end

      it "retrieves schema" do
        expect(subject.client.schema).to be_a Graphlient::Schema
      end
    end

    context "when fetching api resources" do
      let(:version) { "0.19.test" }
      let(:data) { { decidim: { applicationName: "Decidim test", version: version } } }

      before do
        subject.client = Graphlient::Client.new(url, schema_path: "#{__dir__}/schema.json")
        stub_request(:post, url)
          .to_return(status: 200, body: "{\"data\":#{data.to_json}}", headers: {})
      end

      it "returns name and version" do
        expect(subject.name_and_version.version).to eq(version)
      end

      it "executes method when fetch query exists" do
        expect { subject.fetch_name_and_version }.not_to raise_error
      end

      it "returns valid version" do
        expect(subject.valid?).to eq true
      end

      context "when specifying a specific version number" do
        it "returns invalid version" do
          expect(subject.valid?("0.20")).to eq false
        end
      end

      context "when version is less than required" do
        let(:version) { "0.17" }

        it "returns invalid endpoint" do
          expect(subject.valid?).to eq false
          expect(subject.error).to include "Decidim version"
        end
      end
    end

    it "raise error when fetch query does not exists" do
      expect { subject.fetch_something }.to raise_error NameError
      expect(subject.respond_to?(:fetch_something)).to eq true
    end

    it "raise error when is not a fetch query" do
      expect { subject.something }.to raise_error NoMethodError
      expect(subject.respond_to?(:something)).to eq false
    end
  end
end
