# frozen_string_literal: true

require "graphlient"

module Decidim
  module ComparativeStats
    # Class used to fetch and validate Decidim API calls
    class ApiFetcher
      def initialize(endpoint)
        @errors = []
        @client = Graphlient::Client.new(endpoint,
                                         # headers: {
                                         #   'Authorization' => 'Bearer 123'
                                         # },
                                         http_options: {
                                           read_timeout: 20,
                                           write_timeout: 30
                                         })
      end

      attr_reader :client, :errors

      # Queries the GraphQL api using one of the constants in ApiQueries class
      def query(tag)
        begin
          return client.query "Decidim::ComparativeStats::ApiQueries::#{tag.upcase}".constantize
        rescue Faraday::Error
          @errors << "Not a valid Decidim API URL"
        rescue Graphlient::Errors::Error => e
          @errors << e.message
        end
        false
      end

      # Checks if is a valid Decidim API URL
      def valid?
        response = fetch_name_and_version
        return false unless response

        if Gem::Version.new(MIN_API_VERSION) > Gem::Version.new(response.data.decidim.version)
          @errors << "Decidim version detect (#{response.data.decidim.version}) should be at least #{MIN_API_VERSION}"
          return false
        end
        true
      end

      # returns the last error
      def error
        @errors.last
      end

      private

      # Syntactic sugar to query ApiQueries constants as methods:
      # i.e:
      #      ApiQuery::NAME_AND_VERSION => fetch_name_and_version
      def method_missing(name)
        _, key = name.to_s.split("fetch_")
        if key
          query key
        else
          super
        end
      end

      def respond_to_missing?(method_name, include_private = false)
        method_name.to_s.start_with?("fetch_") || super
      end
    end
  end
end
