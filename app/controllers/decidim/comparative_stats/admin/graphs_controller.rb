# frozen_string_literal: true

module Decidim
  module ComparativeStats
    module Admin
      class GraphsController < ComparativeStats::Admin::ApplicationController
        helper_method :active_endpoints, :timeline_graph, :global_metrics_graph, :global_metric_timelines_graph
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

        def global_metrics_graph
          metrics = {}
          active_endpoints.each do |endpoint|
            endpoint.api.fetch_global_metrics.data.metrics.each do |item|
              metrics[item.name] ||= {}
              metrics[item.name][endpoint.name] = item.count
            end
          end
          metrics
        end

        def global_metric_timelines_graph
          history = {}
          active_endpoints.each do |endpoint|
            endpoint.api.fetch_global_history_metrics.data.metrics.each do |item|
              history[item.name] ||= []
              history[item.name] << {
                name: endpoint.name,
                data: item.history.map do |i|
                  [i.key, i.value]
                end.to_h
              }
            end
          end
          history
        end
      end
    end
  end
end
