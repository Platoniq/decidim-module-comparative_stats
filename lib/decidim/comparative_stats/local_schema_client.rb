# frozen_string_literal: true

require "graphlient"

module Decidim
  module ComparativeStats
    # Decidim disables introspection on its API, so Graphlient cannot download
    # the remote schema it needs to parse the queries. The schema of the local
    # Decidim installation is used instead.
    class LocalSchemaClient < Graphlient::Client
      class << self
        # Built from the introspection result, and not from the schema class, so
        # custom scalars are returned as plain JSON values
        def local_schema
          @local_schema ||= GraphQL::Client.load_schema(local_introspection_result)
        end

        private

        def local_introspection_result
          Decidim::Api::Schema.execute(
            GraphQL::Introspection::INTROSPECTION_QUERY,
            context: { scopes: ::Doorkeeper::OAuth::Scopes.from_string("api:read") }
          ).to_h
        end
      end

      def schema
        @schema ||= Graphlient::Schema.new(http, self.class.local_schema)
      end
    end
  end
end
