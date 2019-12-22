# frozen_string_literal: true

module Decidim
  module ComparativeStats
    module Admin
      class GraphsController < ApplicationController
        helper_method :active_endpoints, :timeline_graph
        layout "decidim/admin/comparative_stats"

        def index
          enforce_permission_to :index, :graph
        end

        def active_endpoints
          @active_endpoints ||= Endpoint.active.where(organization: current_organization)
        end

        def timeline_graph
          rows = []
          active_endpoints.each do |endpoint|
            endpoint.api.fetch_participatory_processes.data.participatory_processes.each do |item|
              rows << {
                name: endpoint.name,
                title: item.title.translations.first.text,
                start_date: item.start_date,
                end_date: item.end_date
              }
            end
          end
          rows
        end
      end
    end
  end
end
