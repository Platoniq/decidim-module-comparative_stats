# frozen_string_literal: true

require "spec_helper"

module Decidim::ComparativeStats
  describe ApiFetcher do
    let(:subject) { described_class.new(url) }
    let(:url) { "http://example/api" }

    before do
      stub_request(:post, url).to_return(
        status: 200,
        body: Decidim::Api::Schema.execute(GraphQL::Introspection::INTROSPECTION_QUERY).to_json
      )
    end

    it "retrieves schema" do
      expect(subject.client.schema).to be_a Graphlient::Schema
    end

    it "executes method when fetch query exists" do
      expect { subject.fetch_name_and_version }.not_to raise_error
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
