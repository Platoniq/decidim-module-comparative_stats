# frozen_string_literal: true

module Decidim::ComparativeStats
  class Endpoint < ApplicationRecord
    self.table_name = "decidim_comparative_stats_endpoints"

    belongs_to :organization, foreign_key: :decidim_organization_id, class_name: "Decidim::Organization"

    scope :active, -> { where(active: true) }

    def api
    	@api ||= ApiFetcher.new endpoint
    end

    def name
    	api.fetch_name_and_version.data.decidim.application_name
    end
  end
end
