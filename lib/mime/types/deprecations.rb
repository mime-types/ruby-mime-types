# frozen_string_literal: true

require "mime/types/logger"

# The namespace for MIME applications, tools, and libraries.
module MIME
  ##
  class Types
    # Used to mark a method as deprecated in the mime-types interface.
    def self.deprecated(klass, sym, message = nil, &block) # :nodoc:
      level =
        case klass
        when Class, Module
          "."
        else
          klass = klass.class
          "#"
        end

      sym, pre_message = sym.shift if sym.is_a?(Hash)
      pre_message = " #{pre_message}" if pre_message

      message =
        case message
        when :private, :protected
          " and will be made #{message}"
        when nil
          " and will be removed"
        when ""
          nil
        else
          " #{message}"
        end

      MIME::Types.logger.warn <<-WARNING.chomp.strip
        #{caller(2..2).first}: #{klass}#{level}#{sym}#{pre_message} is deprecated#{message}.
      WARNING

      return unless block
      block.call
    end
  end
end
