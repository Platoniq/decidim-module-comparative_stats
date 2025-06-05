# frozen_string_literal: true

module Decidim
  module ComparativeStats
    # This cell renders a map with participatory spaces
    # the `model` is spected to be a collection of API endpoints
    class ParticipatorySpacesGeocodedEventsCell < Decidim::ViewModel
      include Decidim::MapHelper
      include Decidim::LayoutHelper

      def show
        return unless model

        render :show
      end

      def endpoints
        model
      end

      # rubocop:disable Metrics/CyclomaticComplexity
      # rubocop:disable Metrics/PerceivedComplexity
      def geocoded_events
        @events = {}

        endpoints.each do |endpoint|
          # skip endpoints under version 0.21
          next unless endpoint.api.valid? "0.21"

          @events[endpoint.id] = {
            name: endpoint.name,
            meetings: {},
            proposals: {}
          }
          results = endpoint.api.fetch_global_events
          next unless results.respond_to? :data

          results.data.assemblies.each do |assembly|
            assembly.components.each do |component|
              if component.respond_to? :meetings
                component.meetings.edges.each do |edge|
                  add_meeting(edge.node.to_h, endpoint, assembly, component, :assemblies)
                end
              elsif componet.respond_to? :proposals
                component.proposals.edges.each do |edge|
                  add_proposal(edge.node.to_h, endpoint, assembly, component, :assemblies)
                end
              end
            end
          end
          results.data.participatory_processes.each do |participatory_process|
            participatory_process.components.each do |component|
              if component.respond_to? :meetings
                component.meetings.edges.each do |edge|
                  add_meeting(edge.node.to_h, endpoint, participatory_process, component, :processes)
                end
              elsif component.respond_to? :proposals
                component.proposals.edges.each do |edge|
                  add_proposal(edge.node.to_h, endpoint, participatory_process, component, :processes)
                end
              end
            end
          end
        end
        @events.to_json
      end
      # rubocop:enable Metrics/CyclomaticComplexity
      # rubocop:enable Metrics/PerceivedComplexity

      def first_translation(text)
        return text unless text.is_a? Hash

        translations = text["translations"]
        if translations
          item = translations.find { |i| i["text"].present? }
          return item["text"] || "" if item
        end
        ""
      end

      def add_proposal(proposal, endpoint, participatory_space, component, type)
        @events[endpoint.id][:proposals]["#{type}_proposal_#{proposal["id"]}"] = {
          latitude: proposal["coordinates"]["latitude"],
          longitude: proposal["coordinates"]["longitude"],
          address: proposal["address"],
          title: first_translation(proposal["title"]),
          body: truncate(first_translation(proposal["body"]), length: 100),
          icon: icon("chat-new-line", width: 40, height: 70, remove_icon_class: true),
          link: endpoint.endpoint.remove("api") << "#{type}/#{participatory_space.slug}/f/#{component.id}/proposals/#{proposal["id"]}"
        }
      end

      def add_meeting(meeting, endpoint, participatory_space, component, type)
        @events[endpoint.id][:meetings]["#{type}_meeting_#{meeting["id"]}"] = {
          latitude: meeting["coordinates"]["latitude"],
          longitude: meeting["coordinates"]["longitude"],
          address: meeting["address"],
          title: first_translation(meeting["title"]),
          # description: first_translation(meeting["description"]),
          startTimeDay: l(meeting["startTime"].to_date, format: "%d"),
          startTimeMonth: l(meeting["startTime"].to_date, format: "%B"),
          startTimeYear: l(meeting["startTime"].to_date, format: "%Y"),
          startTime: "#{meeting["startTime"].to_date.strftime("%H:%M")} - #{meeting["endTime"].to_date.strftime("%H:%M")}",
          icon: icon("community-line", width: 40, height: 70, remove_icon_class: true),
          location: first_translation(meeting["location"]),
          locationHints: first_translation(meeting["location_hints"]),
          link: endpoint.endpoint.remove("api") << "#{type}/#{participatory_space.slug}/f/#{component.id}/meetings/#{meeting["id"]}"
        }
      end
    end
  end
end
