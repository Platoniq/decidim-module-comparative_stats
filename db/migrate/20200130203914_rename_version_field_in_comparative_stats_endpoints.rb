# frozen_string_literal: true

class RenameVersionFieldInComparativeStatsEndpoints < ActiveRecord::Migration[5.2]
  def change
    rename_column :decidim_comparative_stats_endpoints, :version, :api_version
  end
end
