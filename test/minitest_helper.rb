# frozen_string_literal: true

gem "minitest"
require "minitest/focus"
require "minitest/hooks"

require "fileutils"

require "mime/type"
ENV["RUBY_MIME_TYPES_LAZY_LOAD"] = "yes"

if ENV["STRICT"]
  $VERBOSE = true
  Warning[:deprecated] = true
  require "minitest/error_on_warning"
end
