# frozen_string_literal: true

if RUBY_VERSION < "2.1"
  warn "Cannot count allocations on #{RUBY_VERSION}."
  exit 1
end

begin
  require "allocation_tracer"
rescue LoadError
  warn "Allocation tracking requires the gem 'allocation_tracer'."
  exit 1
end

module Benchmarks
  # Calculate the number of allocations during loading.
  class LoadAllocations
    def self.report(columnar: false, full: false, top_x: nil, mime_types_only: false)
      new(
        columnar: columnar,
        top_x: top_x,
        mime_types_only: mime_types_only,
        full: full
      ).report
    end

    def initialize(columnar: false, full: false, top_x: nil, mime_types_only: false)
      @columnar = !!columnar
      @full = !!full
      @mime_types_only = !!mime_types_only

      @top_x = top_x

      return unless @top_x

      @top_x = top_x.to_i
      @top_x = 10 if @top_x <= 0
    end

    def report
      collect
      report_top_x if @top_x
      puts "TOTAL Allocations: #{@count}"
    end

    private

    def report_top_x
      table = @allocations.sort_by { |_, v| v.first }.reverse.first(@top_x)
      table.map! { |(location, allocs)|
        next if @mime_types_only && location.first !~ (%r{mime-types/lib})

        [location.join(":").gsub(%r{^#{Dir.pwd}/}, ""), *allocs]
      }.compact!

      head = (ObjectSpace::AllocationTracer.header - [:line]).map { |h|
        h.to_s.split("_").map(&:capitalize).join(" ")
      }
      table.unshift head

      max_widths = [].tap { |mw|
        table.map { |row| row.lazy.map(&:to_s).map(&:length).to_a }.tap do |w|
          w.first.each_index do |i|
            mw << w.lazy.map { |r| r[i] }.max
          end
        end
      }

      pattern = ["%%-%ds"]
      pattern << (["%% %ds"] * (max_widths.length - 1))
      pattern = pattern.join("\t") % max_widths
      table.each do |row|
        puts pattern % row
      end
      puts
    end

    def collect
      @allocations =
        if @columnar
          ObjectSpace::AllocationTracer.trace do
            require "mime/types"
            MIME::Types.first.to_h if @full
          end
        else
          ObjectSpace::AllocationTracer.trace do
            require "mime/types/full"
          end
        end

      @count = ObjectSpace::AllocationTracer.allocated_count_table.values
        .inject(:+)
    end
  end
end
