# frozen_string_literal: true

MIME::Type::ValuePool = Hash.new { |h, k|
  k =
    if k.is_a?(String)
      MIME::Type::ValuePool.intern_string(k)
    else
      begin
        k.dup
      rescue TypeError
        k
      else
        k.freeze
      end
    end

  h[k] = k
}

class << MIME::Type::ValuePool
  if String.method_defined?(:-@)
    def intern_string(string)
      -string
    end
  else
    def intern_string(string)
      string.freeze
    end
  end
end
