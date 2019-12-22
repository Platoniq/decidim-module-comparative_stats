# frozen_string_literal: true

module Decidim
  module ComparativeStats
    module Admin
      class EndpointsController < ApplicationController
        helper_method :organization_endpoints
        layout "decidim/admin/comparative_stats"

        def index
          enforce_permission_to :index, :endpoint
        end

        def new
          enforce_permission_to :create, :endpoint
          @form = form(EndpointForm).instance
        end

        def create
          enforce_permission_to :create, :endpoint
          @form = form(EndpointForm).from_params(params)
          CreateEndpoint.call(@form) do
            on(:ok) do
              flash[:notice] = I18n.t("endpoints.create.success", scope: "decidim.comparative_stats.admin")
              redirect_to endpoints_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("endpoints.create.error", scope: "decidim.comparative_stats.admin")
              render :new
            end
          end
        end

        def organization_endpoints
          @organization_endpoints ||= Endpoint.where(organization: current_organization)
        end
      end
    end
  end
end
