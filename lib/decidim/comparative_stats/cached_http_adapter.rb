# frozen_string_literal: true

require "graphlient/adapters/http/http_adapter"

module Decidim
  module ComparativeStats
    class CachedHTTPAdapter < Graphlient::Adapters::HTTP::FaradayAdapter
      def execute(document:, operation_name: nil, variables: {}, context: {})
        body = {}
        # Strip uniq identifier generated by GraphQL class
        body["query"] = document.to_query_string.gsub(/GraphQL__Client__OperationDefinition_[0-9 ]+/, "")
        body["variables"] = variables if variables.any?

        Rails.cache.fetch(
          "graphlient/api_queries/#{url.hash}/#{body.to_json.hash}",
          expires_in: Decidim::ComparativeStats.stats_cache_expiration_time
        ) do
          super
        end
      end
    end
  end
end