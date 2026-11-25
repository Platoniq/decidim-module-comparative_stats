# frozen_string_literal: true

require "graphlient"
require "spec_helper"

module Decidim::ComparativeStats
  describe CachedHTTPAdapter do
    subject { described_class.new(url) }
    let(:url) { "http://example/api" }
    let(:query) { "query { decidim { version } }" }
    let(:document) { double(to_query_string: query) }
    let(:op_name) { "1234" }
    let(:variables) { {} }
    let(:context) { {} }
    let(:version) { "0.18.1" }
    let(:data) { { "decidim" => { "version" => version } } }

    it "returns expected data" do
      stub_request(:post, url)
        .with(
          body: "{\"query\":\"#{query}\",\"operationName\":\"#{op_name}\",\"variables\":{}}",
          headers: {
            "Content-Type" => "application/json"
          }
        )
        .to_return(status: 200, body: "{\"data\":#{data.to_json}}", headers: { "Content-Type" => "application/json" })
      response = subject.execute(document:, operation_name: op_name, variables:, context:)
      expect(response["data"]).to eq(data)
      expect(response["data"]["decidim"]["version"]).to eq(version)
    end

    it "follows redirects keeping the POST method" do
      stub_request(:post, url)
        .to_return(status: 301, headers: { "Location" => "http://www.example/api" })
      redirected = stub_request(:post, "http://www.example/api")
                   .to_return(status: 200, body: "{\"data\":#{data.to_json}}", headers: { "Content-Type" => "application/json" })

      response = subject.execute(document:, operation_name: op_name, variables:, context:)
      expect(response["data"]).to eq(data)
      expect(redirected).to have_been_requested
    end

    it "raises an error when the response is not a GraphQL one" do
      stub_request(:post, url)
        .to_return(status: 200, body: "<html></html>", headers: { "Content-Type" => "text/html" })

      expect { subject.execute(document:, operation_name: op_name, variables:, context:) }
        .to raise_error(Graphlient::Errors::ServerError, "Not a valid Decidim API URL")
    end
  end
end
