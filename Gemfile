# frozen_string_literal: true

# NOTE: This file is not the canonical source of dependencies. Edit the
# Rakefile, instead.

source "https://rubygems.org/"

gem "mime-types-data", path: "../mime-types-data" if ENV["DEV"]

if ENV["DEV"]
  gem "byebug"
  gem "benchmark-ips"
  gem "memory_profiler"
  gem "allocation_tracer"
end

gemspec

# vim: syntax=ruby
