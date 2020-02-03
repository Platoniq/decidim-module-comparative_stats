# frozen_string_literal: true

require "decidim/core/test/factories"

FactoryBot.define do
  factory :endpoint, class: "Decidim::ComparativeStats::Endpoint" do
    # endpoint { Faker::Internet.url }
    endpoint { "http://example.com/api" }
    name { Faker::Name.name }
    api_version { Decidim::ComparativeStats::MIN_API_VERSION }
    organization { create :organization }
    active { true }
  end
end
