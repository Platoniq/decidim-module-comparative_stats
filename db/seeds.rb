# frozen_string_literal: true

if !Rails.env.production? || ENV["SEED"]
  print "Creating seeds for comparative_stats...\n" unless Rails.env.test?

  organization = Decidim::Organization.first

  # Set the htmleditor on to facilitate development
  admin_user = Decidim::User.find_by(
    organization: organization,
    email: "admin@example.org"
  )

  # add enpoints bcn - helsinki
  Decidim.traceability.create!(
    Decidim::ComparativeStats::Endpoint,
    admin_user,
    endpoint: "http://localhost:3000/api",
    name: organization.name,
    api_version: Decicim.version,
    organization: organization,
    active: true
  )
  Decidim.traceability.create!(
    Decidim::ComparativeStats::Endpoint,
    admin_user,
    endpoint: "https://www.decidim.barcelona/api",
    name: "Decidim Barcelona",
    api_version: "0.22.0",
    organization: organization,
    active: true
  )
  Decidim.traceability.create!(
    Decidim::ComparativeStats::Endpoint,
    admin_user,
    endpoint: "https://omastadi.hel.fi/api",
    name: "City of Helsinki participationary platform",
    api_version: "0.23.1",
    organization: organization,
    active: false
  )
end
