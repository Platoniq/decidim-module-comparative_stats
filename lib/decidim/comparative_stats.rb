# frozen_string_literal: true

require "decidim/comparative_stats/admin"
require "decidim/comparative_stats/engine"
require "decidim/comparative_stats/admin_engine"
require "decidim/comparative_stats/component"
require "chartkick"

module Decidim
  # This namespace holds the logic of the `ComparativeStats` component. This component
  # allows users to create comparative_stats in a participatory space.
  module ComparativeStats
  	autoload :ApiFetcher, "decidim/comparative_stats/api_fetcher"
  	autoload :ApiQueries, "decidim/comparative_stats/api_queries"
  end
end
