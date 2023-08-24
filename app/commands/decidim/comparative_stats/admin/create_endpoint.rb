# frozen_string_literal: true

module Decidim
  module ComparativeStats
    module Admin
      # A command with all the business logic when creating an endpoint
      class CreateEndpoint < Decidim::Command
        # Public: Initializes the command.
        #
        # form - A form object with the params.
        def initialize(form)
          @form = form
        end

        # Executes the command. Broadcasts these events:
        #
        # - :ok when everything is valid.
        # - :invalid if the form wasn't valid and we couldn't proceed.
        #
        # Returns nothing.
        def call
          return broadcast(:invalid) if form.invalid?

          create_endpoint
          broadcast(:ok)
        end

        private

        attr_reader :form

        def create_endpoint
          Decidim.traceability.create!(
            Decidim::ComparativeStats::Endpoint,
            form.current_user,
            endpoint: form.endpoint,
            name: form.context.api.name_and_version.application_name,
            api_version: form.context.api.name_and_version.version,
            organization: form.current_organization,
            active: form.active
          )
        end
      end
    end
  end
end
