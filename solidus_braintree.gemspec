# frozen_string_literal: true

require_relative 'lib/solidus_braintree/version'

Gem::Specification.new do |spec|
  spec.name          = "solidus_braintree"
  spec.version       = SolidusBraintree::VERSION
  spec.authors       = ["Solidus Team"]
  spec.email         = ["contact@solidus.io"]

  spec.summary       = %q{Adds Solidus support for Braintree v.zero Gateway.}
  spec.description   = %q{Adds Solidus support for Braintree v.zero Gateway.}
  spec.homepage      = "https://solidus.io"
  spec.metadata['source_code_uri'] = 'http://github.com/solidusio-contrib/solidus_braintree'
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "solidus_api", [">= 3.0.0", "< 5"]
  spec.add_dependency "solidus_core", [">= 3.0.0", "< 5"]
  spec.add_dependency "solidus_support"
  spec.add_dependency "braintree", "~> 2.46"

  spec.add_development_dependency "bundler", "~> 2.0"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency 'factory_bot', '~> 4.4'
  spec.add_development_dependency 'rspec-rails'
  spec.add_development_dependency 'capybara', '~> 3.29'
  spec.add_development_dependency 'capybara-screenshot'
  spec.add_development_dependency 'webdrivers'
  spec.add_development_dependency 'ffaker'
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency 'sqlite3'
  spec.add_development_dependency 'database_cleaner'
  spec.add_development_dependency "vcr", '~> 3.0'
  spec.add_development_dependency "webmock"
  spec.add_development_dependency 'simplecov'
end
