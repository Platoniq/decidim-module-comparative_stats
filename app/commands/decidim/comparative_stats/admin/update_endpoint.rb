# frozen_string_literal: true

module Decidim
  module ComparativeStats
    module Admin
      # A command with all the business logic when updating an endpoint
      class UpdateEndpoint < Decidim::Command
        # Public: Initializes the command.
        #
        # form - A form object with the params.
        def initialize(endpoint, form, user)
          @endpoint = endpoint
          @form = form
          @user = user
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if the form wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if form.invalid?

          update_endpoint!
          broadcast(:ok)
        end

        private

        attr_reader :form

        def update_endpoint!
          Decidim.traceability.update!(
            @endpoint,
            @user,
            endpoint: form.endpoint,
            name: form.name,
            api_version: form.context.api.name_and_version.version,
            active: form.active
          )
        end
      end
    end
  end
end
