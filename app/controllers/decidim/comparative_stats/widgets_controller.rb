# frozen_string_literal: true

module Decidim
  module ComparativeStats
    class WidgetsController < Decidim::ApplicationController
      skip_before_action :verify_authenticity_token
      after_action :allow_iframe, only: :show
      helper_method :active_endpoints

      layout "decidim/comparative_stats/widget"

      def show
        render params[:graph]
      end

      def allow_iframe
        response.headers.delete "X-Frame-Options"
      end

      def active_endpoints
        @active_endpoints ||= Endpoint.active.where(organization: current_organization)
      end
    end
  end
end

