# frozen_string_literal: true

module Decidim
  module ComparativeStats
    module Admin
      class AggregatedMapsController < ComparativeStats::Admin::ApplicationController
        helper ComparativeStats::ApplicationHelper
        layout "decidim/admin/comparative_stats"

        def index
          enforce_permission_to :index, :aggregated_maps
        end
      end
    end
  end
end
