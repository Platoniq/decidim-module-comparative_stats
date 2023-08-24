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
        attribute :name, String

        validates :endpoint, presence: true
        validate :valid_api_version

        def valid_api_version
          unless context.api.valid?
            errors.add :endpoint, :invalid
            errors.add :endpoint, context.api.error if context.api.error
          end
        end
      end
    end
  end
end
