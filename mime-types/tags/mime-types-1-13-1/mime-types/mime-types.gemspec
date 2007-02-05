Gem::Specification.new do |s|
  s.name = %q{mime-types}
  s.version = %q{1.13.1}
  s.summary = %q{Manages a MIME Content-Type that will return the Content-Type for a given filename.}
  s.platform = Gem::Platform::RUBY

  s.has_rdoc = true

  s.test_suite_file = %w{tests/tests.rb}

  s.autorequire = %q{mime/types}
  s.require_paths = %w{lib}

  s.files = Dir.glob("**/*").delete_if do |item|
    item.include?("CVS") or item.include?(".svn") or
    item == "install.rb" or item =~ /~$/ or
    item =~ /gem(?:spec)?$/
  end

  s.author = %q{Austin Ziegler}
  s.email = %q{mime-types@halostatue.ca}
  s.homepage = %q{http://www.halostatue.ca/ruby/Mime__Types.html}
  s.description = <<-EOS
Mime::Types README

This is release 1.13 of MIME::Types for Ruby, based on the Perl package of the
same name. It is generally kept in sync with the Perl version of MIME::Types.

This package works on the same concept as mailcap, which uses filename
extensions to determine the file's likely MIME content type. This package does
not analyse files for magic bytes to determine the appropriate actual MIME
content type.

Copyright © 2002 - 2004 Austin Ziegler
Based on prior work copyright © Mark Overmeer

This package is licensed under Ruby's licence, the Perl Artistic licence, or
the GPL version 2 or later.
EOS
end
