# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "mime-types"
  s.version = "1.16.20111022003230"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Austin Ziegler"]
  s.date = "2011-10-22"
  s.description = "This library allows for the identification of a file's likely MIME content\ntype. This is release 1.17. The identification of MIME content type is based\non a file's filename extensions.\n\nMIME::Types for Ruby originally based on and synchronized with MIME::Types for\nPerl by Mark Overmeer, copyright 2001 - 2009. As of version 1.15, the data\nformat for the MIME::Type list has changed and the synchronization will no\nlonger happen.\n\nHomepage::  http://mime-types.rubyforge.org/\nCopyright:: 2002 - 2011, Austin Ziegler\n            Based in part on prior work copyright Mark Overmeer\n\n:include: License.rdoc"
  s.email = ["austin@rubyforge.org"]
  s.extra_rdoc_files = ["History.txt", "Install.txt", "Licence.txt", "Manifest.txt", "README.txt", "History.rdoc", "Licence.rdoc", "README.rdoc"]
  s.files = ["History.txt", "Install.txt", "Licence.txt", "Manifest.txt", "README.txt", "Rakefile", "lib/mime/types.rb", "lib/mime/types.rb.data", "mime-types.gemspec", "setup.rb", "test/test_mime_type.rb", "test/test_mime_types.rb", "History.rdoc", "Licence.rdoc", "README.rdoc", ".gemtest"]
  s.homepage = "http://mime-types.rubyforge.org/"
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "mime-types"
  s.rubygems_version = "1.8.10"
  s.summary = "This library allows for the identification of a file's likely MIME content type"
  s.test_files = ["test/test_mime_type.rb", "test/test_mime_types.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rubyforge>, [">= 2.0.4"])
      s.add_development_dependency(%q<minitest>, [">= 2.6.2"])
      s.add_development_dependency(%q<nokogiri>, ["~> 1.2"])
      s.add_development_dependency(%q<minitest>, ["~> 2.0"])
      s.add_development_dependency(%q<hoe-doofus>, ["~> 1.0"])
      s.add_development_dependency(%q<hoe-gemspec>, ["~> 1.0"])
      s.add_development_dependency(%q<hoe-git>, ["~> 1.0"])
      s.add_development_dependency(%q<hoe-seattlerb>, ["~> 1.0"])
      s.add_development_dependency(%q<hoe>, ["~> 2.12"])
    else
      s.add_dependency(%q<rubyforge>, [">= 2.0.4"])
      s.add_dependency(%q<minitest>, [">= 2.6.2"])
      s.add_dependency(%q<nokogiri>, ["~> 1.2"])
      s.add_dependency(%q<minitest>, ["~> 2.0"])
      s.add_dependency(%q<hoe-doofus>, ["~> 1.0"])
      s.add_dependency(%q<hoe-gemspec>, ["~> 1.0"])
      s.add_dependency(%q<hoe-git>, ["~> 1.0"])
      s.add_dependency(%q<hoe-seattlerb>, ["~> 1.0"])
      s.add_dependency(%q<hoe>, ["~> 2.12"])
    end
  else
    s.add_dependency(%q<rubyforge>, [">= 2.0.4"])
    s.add_dependency(%q<minitest>, [">= 2.6.2"])
    s.add_dependency(%q<nokogiri>, ["~> 1.2"])
    s.add_dependency(%q<minitest>, ["~> 2.0"])
    s.add_dependency(%q<hoe-doofus>, ["~> 1.0"])
    s.add_dependency(%q<hoe-gemspec>, ["~> 1.0"])
    s.add_dependency(%q<hoe-git>, ["~> 1.0"])
    s.add_dependency(%q<hoe-seattlerb>, ["~> 1.0"])
    s.add_dependency(%q<hoe>, ["~> 2.12"])
  end
end
