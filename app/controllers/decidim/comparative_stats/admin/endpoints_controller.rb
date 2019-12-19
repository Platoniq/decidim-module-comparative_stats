# frozen_string_literal: true

module Decidim
  module ComparativeStats
    module Admin
      class EndpointsController < ::Decidim::ComparativeStats::Admin::ApplicationController
        before_action do
          enforce_permission_to :update, :organization, organization: current_organization
        end

        def index; end
      end
    end
  end
end
