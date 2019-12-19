# frozen_string_literal: true

require "decidim/core/test/factories"

FactoryBot.define do
  factory :comparative_stats_component, parent: :component do
    name { Decidim::Components::Namer.new(participatory_space.organization.available_locales, :comparative_stats).i18n_name }
    manifest_name { :comparative_stats }
    participatory_space { create(:participatory_process, :with_steps) }
  end

  # Add engine factories here
end
