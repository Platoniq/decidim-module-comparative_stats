# frozen_string_literal: true

require "chartkick"
require "chartkick/helper"

module Decidim
  module ComparativeStats
    # This cell renders an graph with participatory processes
    # the `model` is expected to be a collection of API endpoints
    #
    class ParticipatoryProcessesTimelineCell < Decidim::ViewModel
      include Chartkick::Helper

      def show
        return unless model

        render :show
      end

      def endpoints
        model
      end

      def timeline_graph
        rows = []
        endpoints.each do |endpoint|
          endpoint.api.fetch_participatory_processes.data.participatory_processes.each do |item|
            next unless item.start_date

            start_date = Date.parse(item.start_date)
            end_date = Date.parse(item.end_date.presence || Date.current.end_of_year.to_s)
            # let's not trust people writing proper ordered dates
            start_date, end_date = end_date, start_date if start_date > end_date
            rows << {
              name: endpoint.name,
              title: first_text(item.title.translations),
              start_date: start_date,
              end_date: end_date
            }
          end
        end
        rows
      end

      def first_text(translations)
        item = translations.find { |i| i.text.present? }
        item&.text || ""
      end
    end
  end
end
