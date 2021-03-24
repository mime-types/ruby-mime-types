# frozen_string_literal: true

module Benchmarks
  # Benchmark object counts
  class ObjectCounts
    def self.report(columnar: false, full: false)
      new(columnar: columnar, full: full).report
    end

    def initialize(columnar: false, full: false)
      @columnar = columnar
      @full = full
    end

    def report
      collect
      @before.keys.grep(/T_/).map { |key|
        [key, @after[key] - @before[key]]
      }.sort_by { |_, delta| -delta }.each { |key, delta|
        puts "%10s +%6d" % [key, delta]
      }
    end

    private

    def collect
      @before = count_objects

      if @columnar
        require "mime/types"
        MIME::Types.first.to_h if @full
      else
        require "mime/types/full"
      end

      @after = count_objects
    end

    def count_objects
      GC.start
      ObjectSpace.count_objects
    end
  end
end
