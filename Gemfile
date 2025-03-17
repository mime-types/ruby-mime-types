# -*- ruby -*-
# frozen_string_literal: true

# NOTE: This file is not the canonical source of dependencies. Edit the Rakefile, instead.

source "https://rubygems.org/"

group :profile do
  gem "debug", platforms: [:mri]
  gem "ruby-prof", platforms: [:mri]
  gem "memory_profiler", platforms: [:mri]
end

group :data do
  gem "mime-types-data", path: "../mime-types-data"
end

group :coverage do
  gem "simplecov", require: false, platforms: [:mri]
  gem "simplecov-lcov", require: false, platforms: [:mri]
end

gemspec
