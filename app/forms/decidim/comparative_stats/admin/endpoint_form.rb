# frozen_string_literal: true

module Decidim
  module ComparativeStats
    module Admin
      # A form object used to configure the endpoint.
      #
      class EndpointForm < Decidim::Form
        mimic :endpoint

        attribute :endpoint, String
        attribute :active, Boolean

        validate :api_version

        def api_version
          unless api.valid?
            errors.add :endpoint, :invalid
            errors.add :endpoint, api.error if api.error
          end
        end

        def api
          api ||= ApiFetcher.new endpoint
        end
      end
    end
  end
end
