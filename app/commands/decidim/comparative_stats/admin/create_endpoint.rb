# frozen_string_literal: true

module Decidim
  module ComparativeStats
    module Admin
      # A command with all the business logic when creating an endpoint
      class CreateEndpoint < Rectify::Command
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

        attr_reader :form, :endpoint

        def create_endpoint
          @endpoint = Endpoint.new

          @endpoint.endpoint = form.endpoint
          @endpoint.active = form.active
          @endpoint.organization = form.current_organization
          @endpoint.save!

          Decidim.traceability.create!(
            Endpoint,
            form.current_user,
            endpoint: form.endpoint,
            name: name_and_version.application_name,
            version: name_and_version.version,
            organization: form.current_organization,
            active: form.active
          )
        end

        # When creating name and version are fetched from the api
        # Update action should allow the user to change the name but not the version
        def name_and_version
          @name_and_version ||= form.api.fetch_name_and_version.data.decidim
        end
      end
    end
  end
end
