# frozen_string_literal: true

require 'benchmark'
require 'mime/types'

module Benchmarks
  # Benchmark loading speed
  class Load
    def self.report(load_path, repeats)
      new(load_path, repeats.to_i).report
    end

    def initialize(load_path, repeats = nil)
      @cache_file = File.expand_path('../cache.mtc', __FILE__)
      @repeats    = repeats.to_i
      @repeats    = 50 if @repeats <= 0
      @load_path  = load_path
    end

    def reload_mime_types(repeats = 1, force: false, columnar: false, cache: false)
      loader = MIME::Types::Loader.new

      repeats.times {
        types = MIME::Types::Cache.load if cache
        unless types
          types = loader.load(columnar: columnar)
          MIME::Types::Cache.save(types) if cache
        end
        types.first.to_h if force
      }
    end

    def report
      remove_cache

      Benchmark.bm(30) do |mark|
        mark.report('Normal') do reload_mime_types(@repeats) end
        mark.report('Columnar') do
          reload_mime_types(@repeats, columnar: true)
        end
        mark.report('Columnar Full') do
          reload_mime_types(@repeats, columnar: true, force: true)
        end

        ENV['RUBY_MIME_TYPES_CACHE'] = @cache_file
        mark.report('Cache Initialize') do reload_mime_types(cache: true) end
        mark.report('Cached') do reload_mime_types(@repeats, cache: true) end

        remove_cache
        ENV['RUBY_MIME_TYPES_CACHE'] = @cache_file
        mark.report('Columnar Cache Initialize') do
          reload_mime_types(columnar: true, cache: true)
        end
        mark.report('Columnar Cached') {
          reload_mime_types(@repeats, columnar: true, cache: true)
        }
      end
    ensure
      remove_cache
    end

    def remove_cache
      File.unlink(@cache_file) if File.exist?(@cache_file)
    end
  end
end
