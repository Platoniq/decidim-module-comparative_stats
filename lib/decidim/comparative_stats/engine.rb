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
        get "widgets/:graph", to: "widgets#show", as: :widget
        root to: "widgets#show"
      end

      initializer "decidim_comparative_stats.mount_routes" do
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

      initializer "decidim.comparative_stats.content_blocks" do
        Decidim.content_blocks.register(:homepage, :multinenant_upcoming_events) do |content_block|
          content_block.cell = "decidim/comparative_stats/content_blocks/participatory_processes_geocod_events"
          # content_block.settings_form_cell = "decidim/content_blocks/hero_settings_form"
          content_block.public_name_key = "decidim.comparative_stats.content_blocks.geocod_events"

          # content_block.default!
        end
      end
    end
  end
end
