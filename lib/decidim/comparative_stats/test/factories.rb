# frozen_string_literal: true

require "decidim/core/test/factories"

FactoryBot.define do
  factory :endpoint, class: "Decidim::ComparativeStats::Endpoint" do
    endpoint { Faker::Internet.url }
    name { Faker::Name.name }
    version { Decidim::ComparativeStats::MIN_API_VERSION }
    organization { create(:organization) }
  end
end
