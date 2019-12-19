# frozen_string_literal: true

require "rails"
require "decidim/core"

module Decidim
  module ComparativeStats
    # This is the engine that runs on the public interface of comparative_stats.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::ComparativeStats

      routes do
        # Add engine routes here
        # resources :comparative_stats
        # root to: "comparative_stats#index"
      end

      initializer "decidim_comparative_stats.assets" do |app|
        app.config.assets.precompile += %w(decidim_comparative_stats_manifest.js decidim_comparative_stats_manifest.css)
      end
    end
  end
end
