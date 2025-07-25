# frozen_string_literal: true

require "mime/type/columnar"

# MIME::Types::Columnar is used to extend a MIME::Types container to load data
# by columns instead of from JSON or YAML. Column loads of MIME types loaded
# through the columnar store are synchronized with a Mutex.
#
# MIME::Types::Columnar is not intended to be used directly, but will be added
# to an instance of MIME::Types when it is loaded with
# MIME::Types::Loader#load_columnar.
module MIME::Types::Columnar
  LOAD_MUTEX = Mutex.new # :nodoc:

  def self.extended(obj) # :nodoc:
    super
    obj.instance_variable_set(:@__mime_data__, [])
    obj.instance_variable_set(:@__files__, Set.new)
  end

  def __fully_loaded? # :nodoc:
    @__files__.size == 10
  end

  # Load the first column data file (type and extensions).
  def load_base_data(path) # :nodoc:
    @__root__ = path

    each_file_line("content_type", false) do |line|
      line = line.split
      content_type = line.shift
      extensions = line

      type = MIME::Type::Columnar.new(self, content_type, extensions)
      @__mime_data__ << type
      add(type)
    end

    each_file_byte("spri") do |type, byte|
      type.instance_variable_set(:@__sort_priority, byte)
    end

    self
  end

  private

  def each_file_line(name, lookup = true)
    LOAD_MUTEX.synchronize do
      next if @__files__.include?(name)

      i = -1
      column = File.join(@__root__, "mime.#{name}.column")

      IO.readlines(column, encoding: "UTF-8").each do |line|
        line.chomp!

        if lookup
          (type = @__mime_data__[i += 1]) || next
          yield type, line
        else
          yield line
        end
      end

      @__files__ << name
    end
  end

  def each_file_byte(name)
    LOAD_MUTEX.synchronize do
      next if @__files__.include?(name)

      i = -1

      filename = File.join(@__root__, "mime.#{name}.column")

      next unless File.exist?(filename)

      IO.binread(filename).unpack("C*").each do |byte|
        (type = @__mime_data__[i += 1]) || next
        yield type, byte
      end

      @__files__ << name
    end
  end

  def load_encoding
    each_file_line("encoding") do |type, line|
      pool ||= {}
      type.instance_variable_set(:@encoding, pool[line] ||= line)
    end
  end

  def load_docs
    each_file_line("docs") do |type, line|
      type.instance_variable_set(:@docs, opt(line))
    end
  end

  def load_preferred_extension
    each_file_line("pext") do |type, line|
      type.instance_variable_set(:@preferred_extension, opt(line))
    end
  end

  def load_flags
    each_file_line("flags") do |type, line|
      line = line.split
      type.instance_variable_set(:@obsolete, flag(line.shift))
      type.instance_variable_set(:@registered, flag(line.shift))
      type.instance_variable_set(:@signature, flag(line.shift))
      type.instance_variable_set(:@provisional, flag(line.shift))
    end
  end

  def load_xrefs
    each_file_line("xrefs") { |type, line|
      type.instance_variable_set(:@xrefs, dict(line, transform: :array))
    }
  end

  def load_friendly
    each_file_line("friendly") { |type, line|
      type.instance_variable_set(:@friendly, dict(line))
    }
  end

  def load_use_instead
    each_file_line("use_instead") do |type, line|
      type.instance_variable_set(:@use_instead, opt(line))
    end
  end

  def dict(line, transform: nil)
    if line == "-"
      {}
    else
      line.split("|").each_with_object({}) { |l, h|
        k, v = l.split("^")
        v = nil if v.empty?

        if transform
          send(:"dict_#{transform}", h, k, v)
        else
          h[k] = v
        end
      }
    end
  end

  def dict_extension_priority(h, k, v)
    return if v.nil?

    v = v.to_i if v.is_a?(String)
    v = v.trunc if v.is_a?(Float)
    v = [[-20, v].max, 20].min

    return if v.zero?

    h[k] = v
  end

  def dict_array(h, k, v)
    h[k] = Array(v)
  end

  def arr(line)
    if line == "-"
      []
    else
      line.split("|").flatten.compact.uniq
    end
  end

  def opt(line)
    line unless line == "-"
  end

  def flag(line)
    line == "1"
  end
end
