# frozen_string_literal: true

module Decidim
  module ComparativeStats
    module AdminLog
      # This class holds the logic to present a `Decidim::ComparativeStats::Endpoint`
      # for the `AdminLog` log.
      #
      # Usage should be automatic and you shouldn't need to call this class
      # directly, but here's an example:
      #
      #    action_log = Decidim::ActionLog.last
      #    view_helpers # => this comes from the views
      #    EndpointPresenter.new(action_log, view_helpers).present
      class EndpointPresenter < Decidim::Log::BasePresenter
        private

        def diff_fields_mapping
          {
            endpoint: :string,
            name: :string,
            version: :string,
            active: :boolean
          }
        end

        def i18n_labels_scope
          "activemodel.attributes.comparative_stats.endpoint"
        end

        def action_string
          case action
          when "create", "delete", "update"
            "decidim.comparative_stats.admin_log.endpoint.#{action}"
          else
            super
          end
        end

        def has_diff?
          action == "delete" || super
        end
      end
    end
  end
end
