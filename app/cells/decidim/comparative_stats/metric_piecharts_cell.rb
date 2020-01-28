# frozen_string_literal: true

require "chartkick"
require "chartkick/helper"

module Decidim
  module ComparativeStats
    class MetricPiechartsCell < Decidim::ViewModel
      include Chartkick::Helper

      def show
        return unless model

        render :show
      end

      def endpoints
        model
      end

      def metrics
        metrics = {}
        endpoints.each do |endpoint|
          endpoint.api.fetch_global_metrics.data.metrics.each do |item|
            metrics[item.name] ||= {}
            metrics[item.name][endpoint.name] = item.count
          end
        end
        metrics
      end
    end
  end
end
