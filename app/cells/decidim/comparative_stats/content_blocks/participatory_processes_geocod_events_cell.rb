# frozen_string_literal: true

module Decidim
  module ComparativeStats
    # This cell renders a map with participatory processes
    # the `model` is spected to be a collection of API endpoints
    #
    module ContentBlocks
      class ParticipatoryProcessesGeocodEventsCell < Decidim::ViewModel

        view_paths << "#{Decidim::ComparativeStats::Engine.root}/app/cells/decidim/comparative_stats/content_blocks/partipatory_processes_geocod_events"

        def show
          render :show
        end

        def endpoints
          Decidim::ComparativeStats::Endpoint.first
        end

        def upcoming_events
          events = {}
          data = endpoints.api.fetch_global_events.data
          byebug
          # endpoints.each do |endpoint|
            # endpoint.api.fetch_global_events.data.each do |item|
            #   events[item.name] ||= {}
            # end
          # end
          events
        end
      end
    end
  end
end
