# frozen_string_literal: true

require "graphlient"

module Decidim
  module ComparativeStats
    # Graphlient downloads the remote schema (through an introspection query) in
    # order to parse and validate the queries before sending them. Decidim
    # disables introspection on its API, that request answers with an
    # INTROSPECTION_DISABLED_ERROR and no "data" key, making Graphlient fail.
    #
    # This client uses the schema of the local Decidim installation instead, so
    # no introspection request is performed against the remote endpoint.
    class LocalSchemaClient < Graphlient::Client
      class << self
        # The schema is built from its introspection result, and not from the
        # Decidim::Api::Schema class, so custom scalars (dates, times) are
        # returned as plain JSON values, just as a remote schema would do.
        def local_schema
          @local_schema ||= GraphQL::Client.load_schema(local_introspection_result)
        end

        private

        def local_introspection_result
          Decidim::Api::Schema.execute(
            GraphQL::Introspection::INTROSPECTION_QUERY,
            # decidim-api requires the scopes on every execution context
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
