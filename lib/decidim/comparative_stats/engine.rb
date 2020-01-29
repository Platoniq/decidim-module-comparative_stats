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
        get "widgets/:graph", to: "widgets#show", as: "widget"
        root to: "widgets#show"
      end

      initializer "decidim_comparative_stats.admin_mount_routes" do
        Decidim::Core::Engine.routes do
          mount Decidim::ComparativeStats::Engine, at: "/comparative_stats", as: "decidim_comparative_stats"
        end
      end

      initializer "decidim_comparative_stats.add_cells_view_paths" do
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::ComparativeStats::Engine.root}/app/cells")
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::ComparativeStats::Engine.root}/app/views") # for partials
      end

      initializer "decidim_comparative_stats.assets" do |app|
        app.config.assets.precompile += %w(decidim_comparative_stats_manifest.js)
      end
    end
  end
end
