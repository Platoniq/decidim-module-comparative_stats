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

      initializer "decidim_comparative_stats.add_cells_view_paths" do
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::ComparativeStats::Engine.root}/app/cells")
        Cell::ViewModel.view_paths << File.expand_path("#{Decidim::ComparativeStats::Engine.root}/app/views") # for partials
      end

      initializer "decidim_comparative_stats.admin_assets" do |app|
        app.config.assets.precompile += %w(admin/decidim_comparative_stats_manifest.js)
      end

      def load_seed
        nil
      end

      initializer "decidim_comparative_stats.admin_menu" do
        Decidim.menu :admin_menu do |menu|
          menu.item I18n.t("menu.comparative_stats", scope: "decidim.admin"),
                    decidim_admin_comparative_stats.endpoints_path,
                    icon_name: "graph",
                    position: 3.5,
                    active: is_active_link?(decidim_admin_comparative_stats.endpoints_path, :inclusive) ||
                            is_active_link?(decidim_admin_comparative_stats.graphs_path, :inclusive)
        end
      end
    end
  end
end
