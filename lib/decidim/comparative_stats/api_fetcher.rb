# frozen_string_literal: true

require "graphlient"
require "decidim/comparative_stats/version"

module Decidim
  module ComparativeStats
    # Class used to fetch and validate Decidim API calls
    class ApiFetcher
      def initialize(endpoint)
        @errors = []
        @queries = {}
        @endpoint = endpoint
      end

      attr_reader :errors, :endpoint

      attr_writer :client

      def client
        @client ||= Graphlient::Client.new(endpoint,
                                           http: CachedHTTPAdapter,
                                           http_options: {
                                             read_timeout: 20,
                                             write_timeout: 30
                                           })
      end

      # When creating name and version are fetched from the api
      # Update action should allow the user to change the name but not the version
      def name_and_version
        @name_and_version ||= fetch_name_and_version.data.decidim
      end

      # Queries the GraphQL api using one of files in lib/decidim/comparative_stats/queries
      def query(tag)
        @queries[tag] ||= client.query versioned_query(tag)
      rescue Faraday::Error
        @errors << "Not a valid Decidim API URL"
      rescue Graphlient::Errors::Error => e
        @errors << e.message
      end

      # Checks if is a valid Decidim API URL
      def valid?(min_version = MIN_API_VERSION)
        response = fetch_name_and_version
        return false unless response

        if Gem::Version.new(min_version) > Gem::Version.new(response.data.decidim.version)
          @errors << "Decidim version detect (#{response.data.decidim.version}) should be at least #{min_version}"
          return false
        end
        true
      end

      # returns the last error
      def error
        @errors.last
      end

      private

      def versioned_query(tag)
        file = File.join(__dir__, "queries", "#{tag}.graphql")
        raise NameError unless File.exist?(file)

        unless tag == "name_and_version"
          if Gem::Version.new(name_and_version.version) < Gem::Version.new("0.23")
            alt_file = File.join(__dir__, "queries", "v022", "#{tag}.graphql")
            file = alt_file if File.exist?(alt_file)
          end
        end
        File.open(file).read
      end

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
