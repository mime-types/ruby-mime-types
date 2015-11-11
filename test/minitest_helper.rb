# -*- ruby encoding: utf-8 -*-

require 'mime/type'
require 'fileutils'

gem 'minitest'
require 'fivemat/minitest/autorun'
require 'minitest/focus'
require 'minitest/rg'
require 'minitest-bonus-assertions'

ENV['RUBY_MIME_TYPES_LAZY_LOAD'] = 'yes'
