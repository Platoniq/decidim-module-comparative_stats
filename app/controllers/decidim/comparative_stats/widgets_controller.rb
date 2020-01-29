# frozen_string_literal: true

module Decidim
  module ComparativeStats
    class WidgetsController < Decidim::ApplicationController
      helper ComparativeStats::ApplicationHelper
      skip_before_action :verify_authenticity_token
      after_action :allow_iframe, only: :show

      layout "decidim/comparative_stats/widget"

      def show
        render params[:graph]
      end

      def allow_iframe
        response.headers.delete "X-Frame-Options"
      end
    end
  end
end
