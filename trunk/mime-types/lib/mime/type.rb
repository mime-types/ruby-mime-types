#:title: MIME::Types
#:main: MIME::Types
#--
# MIME::Types for Ruby
# Version 1.13.1
#
# Copyright (c) 2002 - 2004 Austin Ziegler
#
# $Id$
#
# The ChangeLog contains all details on revisions.
#++
# TODO include ../../ChangeLog
module MIME #:nodoc:
    # Reflects a MIME Content-Type which is in invalid format (e.g., it isn't
    # in the form of type/subtype).
  class InvalidContentType < RuntimeError; end

    # == Summary
    # Definition of one MIME content-type
    #
    # == Synopsis
    #  require 'mime/types'
    #
    #  plaintext = MIME::Types['text/plain']
    #  print plaintext.media_type           # => 'text'
    #  print plaintext.sub_type             # => 'plain'
    #
    #  puts plaintext.extensions.join(" ")  # => 'asc txt c cc h hh cpp'
    #
    #  puts plaintext.encoding              # => 8bit
    #  puts plaintext.binary?               # => false
    #  puts plaintext.ascii?                # => true
    #  puts plaintext == 'text/plain'       # => true
    #  puts MIME::Type.simplified('x-appl/x-zip') # => 'appl/zip'
    #
  class Type
    VERSION = '1.13.1' #:nodoc:

    include Comparable

    CONTENT_TYPE_RE = %r{^([-\w.+]+)/([-\w.+]*)$}o #:nodoc:
    UNREGISTERED_RE = %r{^[Xx]-}o #:nodoc:
    ENCODING_RE     = %r{^(?:base64|7bit|8bit|quoted\-printable)$}o #:nodoc:
    PLATFORM_RE     = %r|#{RUBY_PLATFORM}|o #:nodoc:

    SIGNATURES      = %w(application/pgp-keys application/pgp application/pgp-signature application/pkcs10 application/pkcs7-mime application/pkcs7-signature text/vcard) #:nodoc:

      # Returns +true+ if the simplified type matches the current 
    def like?(other)
      if other.respond_to?(:simplified)
        @simplified == other.simplified
      else
        @simplified == Type.simplified(other)
      end
    end

      # Compares the MIME::Type against the exact content type or the
      # simplified type (the simplified type will be used if comparing against
      # something that can be treated as a String with #to_s).
    def <=>(other) #:nodoc:
      if other.respond_to?(:content_type)
        @content_type <=> other.content_type
      elsif other.respond_to?(:to_s)
        @simplified <=> Type.simplified(other.to_s)
      else
        @content_type <=> other
      end
    end

      # Returns +true+ if the other object is a MIME::Type and the content
      # types match.
    def eql?(other) #:nodoc:
      other.kind_of?(MIME::Type) and self == other
    end

      # Returns the whole MIME content-type string.
    attr_reader :content_type
      # Returns the media type of the simplified MIME type.
      #
      #   text/plain        => text
      #   x-chemical/x-pdb  => chemical
    attr_reader :media_type
      # Returns the media type of the unmodified MIME type.
      #
      #   text/plain        => text
      #   x-chemical/x-pdb  => x-chemical
    attr_reader :raw_media_type
      # Returns the sub-type of the simplified MIME type.
      #
      #   text/plain        => plain
      #   x-chemical/x-pdb  => pdb
    attr_reader :sub_type
      # Returns the media type of the unmodified MIME type.
      # 
      #   text/plain        => plain
      #   x-chemical/x-pdb  => x-pdb
    attr_reader :raw_sub_type
      # The MIME types main- and sub-label can both start with <tt>x-</tt>,
      # which indicates that it is a non-registered name. Of course, after
      # registration this flag can disappear, adds to the confusing
      # proliferation of MIME types. The simplified string has the <tt>x-</tt>
      # removed and are translated to lowercase.
    attr_reader :simplified
      # The list of extensions which are known to be used for this MIME::Type.
      # Non-array values will be coerced into an array with #to_a. Array
      # values will be flattened and +nil+ values removed.
    attr_accessor :extensions
    def extensions=(ext) #:nodoc:
      @extensions = ext.to_a.flatten.compact
    end

      # The encoding (7bit, 8bit, quoted-printable, or base64) required to
      # transport the data of this content type safely across a network, which
      # roughly corresponds to Content-Transfer-Encoding. A value of +nil+ or
      # <tt>:default</tt> will reset the #encoding to the #default_encoding
      # for the MIME::Type. Raises ArgumentError if the encoding provided is
      # invalid.
    attr_accessor :encoding
    def encoding=(enc) #:nodoc:
      if enc.nil? or enc == :default
        @encoding = self.default_encoding
      elsif enc =~ ENCODING_RE
        @encoding = enc
      else
        raise ArgumentError, "The encoding must be nil, :default, base64, 7bit, 8bit, or quoted-printable."
      end
    end

      # The regexp for the operating system that this MIME::Type is specific
      # to.
    attr_accessor :system
    def system=(os) #:nodoc:
      if os.nil? or os.kind_of?(Regexp)
        @system = os
      else
        @system = %r|#{os}|
      end
    end
      # Returns the default encoding for the MIME::Type based on the media
      # type.
    def default_encoding
      (@media_type == 'text') ? 'quoted-printable' : 'base64'
    end

    class << self
        # The MIME types main- and sub-label can both start with <tt>x-</tt>,
        # which indicates that it is a non-registered name. Of course, after
        # registration this flag can disappear, adds to the confusing
        # proliferation of MIME types. The simplified string has the
        # <tt>x-</tt> removed and are translated to lowercase.
      def Type.simplified(content_type)
        matchdata = CONTENT_TYPE_RE.match(content_type)

        if matchdata.nil?
          simplified = nil
        else
          media_type = matchdata.captures[0].downcase.gsub(UNREGISTERED_RE, '')
          subtype = matchdata.captures[1].downcase.gsub(UNREGISTERED_RE, '')
          simplified = "#{media_type}/#{subtype}"
        end
        simplified
      end

        # Creates a MIME::Type from an array in the form of:
        #   [type-name, [extensions], encoding, system]
        #
        # +extensions+, +encoding+, and +system+ are optional.
        #
        #   MIME::Type.from_array("application/x-ruby", ['rb'], '8bit')
        #   MIME::Type.from_array(["application/x-ruby", ['rb'], '8bit'])
        #
        # See MIME::Type.new for more information.
        #
      def from_array(*args) #:yields MIME::Types.new:
          # Dereferences the array one level, if necessary.
        args = args[0] if args[0].kind_of?(Array)

        if args.size.between?(1, 4)
          m = MIME::Type.new(args[0]) do |t|
            t.extensions = args[1] if args.size > 1
            t.encoding = args[2] if args.size > 2
            t.system = args[3] if args.size > 3
          end
          yield m if block_given?
        else
          raise ArgumentError, "Array provided must contain between one and four elements."
        end
        m
      end

        # Creates a MIME::Type from a hash. Keys are case-insensitive, dashes
        # may be replaced with underscores, and the internal Symbol of the
        # lowercase-underscore version can be used as well. That is,
        # Content-Type can be provided as content-type, Content_Type,
        # content_type, or :content_type.
        #
        # Acceptable keys are <tt>Content-Type</tt>,
        # <tt>Content-Transfer-Encoding</tt>, <tt>Extensions</tt>, and
        # <tt>System</tt>.
        #
        #   MIME::Type.from_hash('Content-Type' => 'text/x-yaml',
        #                        'Content-Transfer-Encoding' => '8bit',
        #                        'System' => 'linux',
        #                        'Extensions' => ['yaml', 'yml'])
        #
        # See MIME::Type.new for more information.
        #
      def from_hash(hash) #:yields MIME::Types.new:
        hash = hash.dup
        hash.each_pair do |k, v| 
          if k.respond_to?(:intern)
            hash[k.tr('-A-Z', '_a-z').intern] = v
            hash.delete(k)
          end
        end

        m = MIME::Type.new(hash[:content_type]) do |t|
          t.extensions = hash[:extensions]
          t.encoding = hash[:content_transfer_encoding]
          t.system = hash[:system]
        end

        yield m if block_given?
        m
      end

        # +arg+ may also be one of MIME::Type, Array, or Hash.
        # [MIME::Type]  Equivalent to a copy constructor.
        #   MIME::Type.new(plaintext)
      def from_mime_type(mime_type) #:yields MIME::Type.new:
        m = MIME::Types.new(mime_type.content_type.dup) do |t|
          t.extensions = mime_type.extensions.dup
          t.system = mime_type.system.dup
          t.encoding = mime_type.encoding.dup
        end

        yield m if block_given?
      end
    end

      # MIME::Types are constructed with an alternative object construction
      # technique where +self+ is +yield+ed after initial construction.
      #
      #   MIME::Type.new('application/x-eruby') do |t|
      #     t.extensions = 'rhtml'
      #     t.encoding = '8bit'
      #   end
      #
      # === Changes
      # In MIME::Types 1.07, the constructor accepted more argument types and
      # called #instance_eval on the optional block provided. This is no
      # longer the case as of 1.13. The full changes are noted below.
      #
      # 1. The constructor +yield+s +self+ instead of using #instance_eval and
      #    that the calls to #init_extensions, #init_encoding, and
      #    #init_system have been eliminated.
      # 2. MIME::Type.new no longer accepts a MIME::Type argument. Use
      #    MIME::Type.from_mime_type instead.
      #
      #     # 1.07
      #   MIME::Type.new(plaintext)
      #     # 1.12
      #   MIME::Type.from_mime_type(plaintext)
      #
      # 3. MIME::Type.new no longer accepts an Array argument. Use
      #    MIME::Type.from_array instead.
      #
      #     # 1.07
      #   MIME::Type.new(["application/x-ruby", ["rb"], "8bit"])
      #     # 1.12
      #   MIME::Type.from_array("application/x-ruby", ['rb'], '8bit')
      #   MIME::Type.from_array(["application/x-ruby", ['rb'], '8bit'])
      #
      # 4. MIME::Type.new no longer accepts a Hash argument. Use
      #    MIME::Type.from_hash instead.
      #
      #     # 1.07
      #   MIME::Type.new('Content-Type' => 'text/x-yaml',
      #                  'Content-Transfer-Encoding' => '8bit',
      #                  'System' => 'linux',
      #                  'Extensions' => ['yaml', 'yml'])
      #     # 1.12
      #   MIME::Type.from_hash('Content-Type' => 'text/x-yaml',
      #                        'Content-Transfer-Encoding' => '8bit',
      #                        'System' => 'linux',
      #                        'Extensions' => ['yaml', 'yml'])
      #
      # *NOTE*:: If the encoding is not specified, then it will be defaulted
      #          to 'quoted-printable' for 'text/*' media types and 'base64'
      #          for every other type. See #encoding for more information.
      #
    def initialize(content_type) #:yields self:
      matchdata = CONTENT_TYPE_RE.match(content_type)

      if matchdata.nil?
        raise InvalidContentType, "Invalid Content-Type provided ('#{content_type}')"
      end

      @content_type = content_type
      @raw_media_type = matchdata.captures[0]
      @raw_sub_type = matchdata.captures[1]

      @simplified = MIME::Type.simplified(@content_type)
      matchdata = CONTENT_TYPE_RE.match(@simplified)
      @media_type = matchdata.captures[0]
      @sub_type = matchdata.captures[1]

      self.extensions = nil
      self.encoding = :default
      self.system = nil

      yield self if block_given?
    end

      # MIME content-types which are not regestered by IANA nor defined in
      # RFCs are required to start with <tt>x-</tt>. This counts as well for a
      # new media type as well as a new sub-type of an existing media type. If
      # either the media-type or the content-type begins with <tt>x-</tt>,
      # this method will return +false+.
    def registered?
      not (@raw_media_type =~ UNREGISTERED_RE) || (@raw_sub_type =~ UNREGISTERED_RE)
    end

      # MIME types can be specified to be sent across a network in particular
      # formats. This method returns +true+ when the MIME type encoding is set
      # to <tt>base64</tt>.
    def binary?
      @encoding == 'base64'
    end

      # MIME types can be specified to be sent across a network in particular
      # formats. This method returns +false+ when the MIME type encoding is
      # set to <tt>base64</tt>.
    def ascii?
      not binary?
    end

      # Returns +true+ when the simplified MIME type is in the list of known
      # digital signatures.
    def signature?
      SIGNATURES.include?(@simplified.downcase)
    end

      # Returns +true+ if the MIME::Type is specific to an operating system.
    def system?
      not @system.nil?
    end

      # Returns +true+ if the MIME::Type is specific to the current operating
      # system as represented by RUBY_PLATFORM.
    def platform?
      system? and (RUBY_PLATFORM =~ @system)
    end

      # Returns +true+ if the MIME::Type specifies an extension list,
      # indicating that it is a complete MIME::Type.
    def complete?
      not @extensions.empty?
    end

      # Returns the MIME type as a string.
    def to_s
      @content_type
    end

      # Returns the MIME type as a string for implicit conversions.
    def to_str
      @content_type
    end

      # Returns the MIME type as an array suitable for use with
      # MIME::Type.from_array.
    def to_a
      [@content_type, @extensions, @encoding, @system]
    end

      # Returns the MIME type as an array suitable for use with
      # MIME::Type.from_hash.
    def to_hash
      { 'Content-Type' => @content_type,
        'Content-Transfer-Encoding' => @encoding,
        'Extensions' => @extensions,
        'System' => @system }
    end
  end
end
