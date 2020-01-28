# frozen_string_literal: true

module Decidim
  module ComparativeStats
    module Admin
      class GraphsController < ComparativeStats::Admin::ApplicationController
        helper_method :active_endpoints
        layout "decidim/admin/comparative_stats"

        def index
          enforce_permission_to :index, :graph
        end

        def active_endpoints
          @active_endpoints ||= Endpoint.active.where(organization: current_organization)
        end
      end
    end
  end
end
