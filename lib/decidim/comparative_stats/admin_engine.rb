# frozen_string_literal: true

module Decidim
  module ComparativeStats
    # This is the engine that runs on the public interface of `ComparativeStats`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::ComparativeStats::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        # Add admin engine routes here
        resources :endpoints
        resources :graphs
        root to: "endpoints#index"
      end

      initializer "decidim_comparative_stats.admin_mount_routes" do
        Decidim::Core::Engine.routes do
          mount Decidim::ComparativeStats::AdminEngine, at: "/admin/comparative_stats", as: "decidim_admin_comparative_stats"
        end
      end

      initializer "decidim_consultations.add_cells_view_paths" do
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::ComparativeStats::Engine.root}/app/cells")
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::ComparativeStats::Engine.root}/app/views") # for partials
      end

      initializer "decidim_comparative_stats.admin_assets" do |app|
        app.config.assets.precompile += %w(admin/decidim_comparative_stats_manifest.js)
      end

      def load_seed
        nil
      end
    end
  end
end
