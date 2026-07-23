# frozen_string_literal: true

require "decidim/comparative_stats/admin"
require "decidim/comparative_stats/engine"
require "decidim/comparative_stats/admin_engine"
require "chartkick"

module Decidim
  # This namespace holds the logic of the `ComparativeStats` component. This component
  # allows users to create comparative_stats in a participatory space.
  module ComparativeStats
    class << self
      def config = self

      def configure
        yield self
      end
    end

    autoload :ApiFetcher, "decidim/comparative_stats/api_fetcher"
    autoload :CachedHTTPAdapter, "decidim/comparative_stats/cached_http_adapter"

    # Sets the expiration time for the statistic data.
    mattr_accessor :stats_cache_expiration_time, default: 24.hours
  end
end
