# frozen_string_literal: true

begin
  require "ruby-prof"
rescue LoadError
  warn "Profiling requires 'ruby-prof'"
  exit 1
end

require "mime-types"

MIME::Types.logger = nil

def profile_columnar
  puts "Profiling columnar load"

  result = RubyProf.profile do
    loader = MIME::Types::Loader.new

    50.times do
      loader.load(columnar: true)
    end
  end

  RubyProf::FlatPrinter.new(result).print($stdout)
end

def profile_columnar_full
  puts "Profiling columnar load, then full load"

  result = RubyProf.profile do
    loader = MIME::Types::Loader.new

    50.times do
      loader.load(columnar: true).first.to_h
    end
  end

  RubyProf::FlatPrinter.new(result).print($stdout)
end

def profile_full
  puts "Profiling full load"

  result = RubyProf.profile do
    loader = MIME::Types::Loader.new

    50.times do
      loader.load(columnar: false)
    end
  end

  RubyProf::FlatPrinter.new(result).print($stdout)
end
