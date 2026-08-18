# frozen_string_literal: true

if !Rails.env.production? || ENV.fetch("SEED", nil)
  print "Creating seeds for comparative_stats...\n" unless Rails.env.test?

  organization = Decidim::Organization.first

  # Set the htmleditor on to facilitate development
  admin_user = Decidim::User.find_by(
    organization:,
    email: "admin@example.org"
  )

  # organization names are translated attributes since Decidim 0.29
  organization_name = if organization.name.is_a?(Hash)
                        organization.name[organization.default_locale.to_s].presence ||
                          organization.name.values.grep(String).find(&:present?)
                      else
                        organization.name
                      end

  # add enpoints bcn - helsinki
  Decidim.traceability.create!(
    Decidim::ComparativeStats::Endpoint,
    admin_user,
    endpoint: "http://localhost:3000/api",
    name: organization_name,
    api_version: Decidim.version,
    organization:,
    active: true
  )
  Decidim.traceability.create!(
    Decidim::ComparativeStats::Endpoint,
    admin_user,
    endpoint: "https://www.decidim.barcelona/api",
    name: "Decidim Barcelona",
    api_version: "0.22.0",
    organization:,
    active: true
  )
  Decidim.traceability.create!(
    Decidim::ComparativeStats::Endpoint,
    admin_user,
    endpoint: "https://omastadi.hel.fi/api",
    name: "City of Helsinki participationary platform",
    api_version: "0.23.1",
    organization:,
    active: false
  )
end
