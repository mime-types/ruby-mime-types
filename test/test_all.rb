#! /usr/bin/env ruby
#--
# MIME::Types
# A Ruby implementation of a MIME Types information library. Based in spirit
# on the Perl MIME::Types information library by Mark Overmeer.
# http://rubyforge.org/projects/mime-types/
#
# Licensed under the Ruby disjunctive licence with the GNU GPL or the Perl
# Artistic licence. See Licence.txt for more information.
#
# Copyright 2003 - 2009 Austin Ziegler
#++

$LOAD_PATH.unshift("#{File.dirname(__FILE__)}/../lib") if __FILE__ == $0

$stderr.puts "Checking for test cases:"

Dir[File.join(File.dirname($0), 'test_*.rb')].each do |testcase|
  next if File.basename(testcase) == File.basename(__FILE__)
  $stderr.puts "\t#{testcase}"
  load testcase
end

$stderr.puts " "
