# frozen_string_literal: true

module Decidim
  module ComparativeStats
    module Admin
      # A command with all the business logic when destroying an endpoint
      class DestroyEndpoint < Rectify::Command
        # Public: Initializes the command.
        #
        # form - A form object with the params.
        def initialize(endpoint, current_user)
          @endpoint = endpoint
          @current_user = current_user
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if the form wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          destroy_endpoint!
          broadcast(:ok)
        end

        private

        attr_reader :current_user

        def destroy_endpoint!
          Decidim.traceability.perform_action!(
            "delete",
            @endpoint,
            current_user
          ) do
            @endpoint.destroy!
          end
        end
      end
    end
  end
end
