# frozen_string_literal: true

module Decidim::ComparativeStats
  class Endpoint < ApplicationRecord
    include Decidim::Traceable
    include Decidim::Loggable

    self.table_name = "decidim_comparative_stats_endpoints"

    belongs_to :organization, foreign_key: :decidim_organization_id, class_name: "Decidim::Organization"

    scope :active, -> { where(active: true) }

    def api
      @api ||= ApiFetcher.new endpoint
    end

    def self.log_presenter_class_for(_log)
      Decidim::ComparativeStats::AdminLog::EndpointPresenter
    end
  end
end
