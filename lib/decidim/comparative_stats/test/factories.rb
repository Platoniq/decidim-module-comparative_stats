# frozen_string_literal: true

require "decidim/core/test/factories"

FactoryBot.define do
  factory :endpoint, class: "Decidim::ComparativeStats::Endpoint" do
    endpoint { Faker::Internet.url }
    organization { create(:organization) }
  end
end
