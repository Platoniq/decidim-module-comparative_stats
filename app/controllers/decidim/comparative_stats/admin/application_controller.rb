# frozen_string_literal: true

module Decidim
  module ComparativeStats
    module Admin
      # This controller is the abstract class from which all other controllers of
      # this engine inherit.
      #
      class ApplicationController < Decidim::Admin::ApplicationController
        register_permissions(::Decidim::Admin::ApplicationController,
                             ::Decidim::ComparativeStats::Admin::Permissions,
                             ::Decidim::Admin::Permissions)
      end
    end
  end
end
