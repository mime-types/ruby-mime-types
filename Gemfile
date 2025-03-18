# -*- ruby -*-
# frozen_string_literal: true

# NOTE: This file is not the canonical source of dependencies. Edit the Rakefile, instead.

source "https://rubygems.org/"

if ENV["DEV"]
  gem "debug", platforms: [:mri]
  gem "ruby-prof", platforms: [:mri]
  gem "memory_profiler", platforms: [:mri]
end

if ENV["DATA"]
  gem "mime-types-data", path: "../mime-types-data"
end

if ENV["COVERAGE"]
  gem "simplecov", require: false, platforms: [:mri]
  gem "simplecov-lcov", require: false, platforms: [:mri]
end

gemspec
