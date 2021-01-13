# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)

require "decidim/comparative_stats/version"

Gem::Specification.new do |s|
  s.version = Decidim::ComparativeStats::VERSION
  s.authors = ["Ivan Vergés"]
  s.email = ["ivan@platoniq.net"]
  s.license = "AGPL-3.0"
  s.homepage = "https://github.com/Platoniq/decidim-module-comparative_stats"
  s.required_ruby_version = ">= 2.6"

  s.name = "decidim-comparative_stats"
  s.summary = "A decidim comparative_stats module"
  s.description = "A module to compare instances of Decidim by using their API."

  s.files = Dir["{app,config,lib,db,vendor}/**/*", "LICENSE-AGPLv3.txt", "Rakefile", "README.md"]

  s.add_dependency "chartkick", "~> 3.3"
  s.add_dependency "decidim-admin", Decidim::ComparativeStats::DECIDIM_VERSION
  s.add_dependency "decidim-core", Decidim::ComparativeStats::DECIDIM_VERSION
  s.add_dependency "graphlient", "~> 0.3"
  s.add_dependency "jquery-tmpl-rails", "~> 1.1"

  s.add_development_dependency "decidim-dev", Decidim::ComparativeStats::DECIDIM_VERSION
end
