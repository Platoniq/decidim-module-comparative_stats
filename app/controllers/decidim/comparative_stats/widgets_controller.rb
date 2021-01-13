# frozen_string_literal: true

module Decidim
  module ComparativeStats
    class WidgetsController < Decidim::ApplicationController
      helper ComparativeStats::ApplicationHelper
      skip_before_action :verify_authenticity_token
      after_action :allow_iframe, only: :show

      helper_method :graphs_path

      layout "decidim/comparative_stats/widget"

      def show
        is_valid = lookup_context.exists?(params[:graph], "decidim/comparative_stats/widgets", true)
        render plain: "not found", status: :not_found unless is_valid
      end

      def allow_iframe
        response.headers.delete "X-Frame-Options"
      end

      private

      # Mock admin path for tabs.html.erb
      def graphs_path(graph)
        decidim_comparative_stats.widget_url graph
      end
    end
  end
end
