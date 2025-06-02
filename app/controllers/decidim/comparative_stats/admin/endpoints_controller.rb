# frozen_string_literal: true

module Decidim
  module ComparativeStats
    module Admin
      class EndpointsController < ComparativeStats::Admin::ApplicationController
        helper_method :organization_endpoints
        layout "decidim/admin/comparative_stats"

        def index
          enforce_permission_to :index, :endpoint
        end

        def new
          enforce_permission_to :create, :endpoint
          @form = form(EndpointForm).instance
        end

        def edit
          enforce_permission_to :update, :endpoint, endpoint: current_endpoint
          @form = form(EndpointForm).from_model(current_endpoint, endpoint: current_endpoint)
        end

        def create
          enforce_permission_to :create, :endpoint
          @form = form(EndpointForm).from_params(params, api:)
          CreateEndpoint.call(@form) do
            on(:ok) do
              flash[:notice] = I18n.t("endpoints.create.success", scope: "decidim.comparative_stats.admin")
              redirect_to decidim_admin_comparative_stats.endpoints_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("endpoints.create.error", scope: "decidim.comparative_stats.admin")
              render :new
            end
          end
        end

        def update
          enforce_permission_to :update, :endpoint, endpoint: current_endpoint

          form = form(EndpointForm).from_params(params, endpoint: current_endpoint, api:)

          UpdateEndpoint.call(current_endpoint, form, current_user) do
            on(:ok) do
              flash[:notice] = I18n.t("endpoints.update.success", scope: "decidim.comparative_stats.admin")
              redirect_to decidim_admin_comparative_stats.endpoints_path
            end

            on(:invalid) do
              flash.now[:alert] = I18n.t("endpoints.update.error", scope: "decidim.comparative_stats.admin")
              render :edit
            end
          end
        end

        def destroy
          enforce_permission_to :destroy, :endpoint, endpoint: current_endpoint

          DestroyEndpoint.call(current_endpoint, current_user) do
            on(:ok) do
              flash[:notice] = I18n.t("endpoints.destroy.success", scope: "decidim.comparative_stats.admin")
              redirect_to decidim_admin_comparative_stats.endpoints_path
            end
          end
        end

        def organization_endpoints
          @organization_endpoints ||= Endpoint.where(organization: current_organization)
        end

        def api
          @api ||= ApiFetcher.new(params[:endpoint][:endpoint])
        end

        def current_endpoint
          @current_endpoint ||= Endpoint.find(params[:id])
        end
      end
    end
  end
end
