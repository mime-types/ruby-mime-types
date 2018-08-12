# frozen_string_literal: true

require 'set'
require 'forwardable'

# MIME::Types requires a serializable keyed container that returns an empty Set
# on a key miss. Hash#default_value cannot be used because, while it traverses
# the Marshal format correctly, it won't survive any other serialization
# format (plus, a default of a mutable object resuls in a shared mess).
# Hash#default_proc cannot be used without a wrapper because it prevents
# Marshal serialization (and doesn't survive the round-trip).
class MIME::Types::Container #:nodoc:
  extend Forwardable

  def initialize
    @container = {}
  end

  def [](key)
    container[key] || EMPTY_SET
  end

  def_delegators :@container,
    :count,
    :each_value,
    :keys,
    :merge,
    :merge!,
    :select,
    :values

  def add(key, value)
    (container[key] ||= Set.new).add(value)
  end

  def marshal_dump
    {}.merge(container)
  end

  def marshal_load(hash)
    @container = hash
  end

  def encode_with(coder)
    container.each { |k, v| coder[k] = v.to_a }
  end

  def init_with(coder)
    coder.map.each { |k, v| container[k] = Set[*v] }
  end

  private

  attr_reader :container

  EMPTY_SET = Set.new.freeze
  private_constant :EMPTY_SET
end
