# frozen_string_literal: true

begin
  require "memory_profiler"
rescue Exception # standard:disable Lint/RescueException
  warn "Memory profiling requires the gem 'memory_profiler'."
  exit 1
end

module Benchmarks
  # Use Memory Profiler to profile memory
  class ProfileMemory
    def self.report(columnar: false, full: false, mime_types_only: false, top_x: nil)
      new(columnar, full, mime_types_only, top_x).report
    end

    def initialize(columnar, full, mime_types_only, top_x)
      @columnar = !!columnar
      @full = !!full
      @mime_types_only = !!mime_types_only

      @top_x = top_x

      return unless @top_x

      @top_x = top_x.to_i
      @top_x = 10 if @top_x <= 0
    end

    def report
      collect.pretty_print
    end

    private

    def collect
      report_params = {
        top: @top_x,
        # allow_files: @mime_types_only ? %r{mime-types/lib/mime/} : nil,
        ignore_files: %r{lib/logger\.rb|lib/logger}
      }.delete_if { |_k, v| v.nil? }

      if @columnar
        MemoryProfiler.report(**report_params) do
          require "mime/types"
          MIME::Types.first.to_h if @full
        end
      else
        MemoryProfiler.report(**report_params) do
          require "mime/types/full"
        end
      end
    end
  end
end
