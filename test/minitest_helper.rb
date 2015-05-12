# -*- ruby encoding: utf-8 -*-

require 'mime/type'
require 'fileutils'

gem 'minitest'
require 'minitest/autorun'
require 'minitest/focus'

module Minitest::MIMEDeprecated
  def assert_deprecated(name, message = "and will be removed")
    assert_output nil,
      /#{Regexp.escape(name)} is deprecated #{Regexp.escape(message)}./ do
      yield
    end
  ensure
  end

  Minitest::Test.send(:include, self)
end
