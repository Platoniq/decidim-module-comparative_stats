# frozen_string_literal: true

module Decidim
  module ComparativeStats
    # Custom helpers, scoped to the comparative_stats engine.
    #
    module ApplicationHelper
      def embed_modal_for(url)
        embed_code = String.new(content_tag(:iframe, "", src: url, frameborder: 0, width: "100%", height: "420", scrolling: "vertical"))
        render partial: "decidim/shared/embed_modal", locals: { js_embed_code: nil, embed_code: embed_code }
      end

      def active_endpoints
        Endpoint.active.where(organization: current_organization)
      end

      def available_graphs
        [
          :global_stats,
          :global_stats_timeline,
          :processes_timeline,
          :spaces_geocoded_events
        ]
      end
    end
  end
end
