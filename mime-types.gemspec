# -*- encoding: utf-8 -*-
# stub: mime-types 2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "mime-types"
  s.version = "2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Austin Ziegler"]
  s.date = "2014-01-03"
  s.description = "The mime-types library provides a library and registry for information about\nMIME content type definitions. It can be used to determine defined filename\nextensions for MIME types, or to use filename extensions to look up the likely\nMIME type definitions.\n\nMIME content types are used in MIME-compliant communications, as in e-mail or\nHTTP traffic, to indicate the type of content which is transmitted. The\nmime-types library provides the ability for detailed information about MIME\nentities (provided as an enumerable collection of MIME::Type objects) to be\ndetermined and used programmatically. There are many types defined by RFCs and\nvendors, so the list is long but by definition incomplete; don't hesitate to to\nadd additional type definitions (see Contributing.rdoc). The primary sources\nfor MIME type definitions found in mime-types is the IANA collection of\nregistrations (see below for the link), RFCs, and W3C recommendations.\n\nThe mime-types library uses semantic versioning. This is release 2.0; there are\nincompatible changes in the API provided by mime-types, mostly around registry\ninitialization (see History.rdoc for full details), and the removal of support\nfor Ruby 1.8 interpreters.\n\nmime-types (previously called MIME::Types for Ruby) was originally based on\nMIME::Types for Perl by Mark Overmeer, copyright 2001 - 2009. It is built to\nconform to the MIME types of RFCs 2045 and 2231. It tracks the {IANA\nregistry}[http://www.iana.org/assignments/media-types/]\n({ftp}[ftp://ftp.iana.org/assignments/media-types]) with some unofficial types\nadded from the {LTSW collection}[http://www.ltsw.se/knbase/internet/mime.htp]\nand added by the users of mime-types."
  s.email = ["austin@rubyforge.org"]
  s.extra_rdoc_files = ["Contributing.rdoc", "History.rdoc", "Licence.rdoc", "Manifest.txt", "README.rdoc", "docs/COPYING.txt", "docs/artistic.txt", "Contributing.rdoc", "History.rdoc", "Licence.rdoc", "README.rdoc"]
  s.files = [".autotest", ".gemtest", ".hoerc", ".minitest.rb", ".travis.yml", "Contributing.rdoc", "Gemfile", "History.rdoc", "Licence.rdoc", "Manifest.txt", "README.rdoc", "Rakefile", "data/mime-types.json", "docs/COPYING.txt", "docs/artistic.txt", "lib/mime-types.rb", "lib/mime.rb", "lib/mime/type.rb", "lib/mime/types.rb", "lib/mime/types/cache.rb", "lib/mime/types/loader.rb", "lib/mime/types/loader_path.rb", "support/benchmarker.rb", "support/convert.rb", "support/iana_downloader.rb", "test/fixture/json.json", "test/fixture/old-data", "test/fixture/yaml.yaml", "test/minitest_helper.rb", "test/test_mime_type.rb", "test/test_mime_types.rb", "test/test_mime_types_cache.rb", "test/test_mime_types_class.rb", "test/test_mime_types_lazy.rb", "test/test_mime_types_loader.rb"]
  s.homepage = "http://mime-types.rubyforge.org/"
  s.licenses = ["MIT", "Artistic 2.0", "GPL-2"]
  s.rdoc_options = ["--main", "README.rdoc"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")
  s.rubyforge_project = "mime-types"
  s.rubygems_version = "2.2.0"
  s.summary = "The mime-types library provides a library and registry for information about MIME content type definitions"
  s.test_files = ["test/test_mime_type.rb", "test/test_mime_types.rb", "test/test_mime_types_cache.rb", "test/test_mime_types_class.rb", "test/test_mime_types_lazy.rb", "test/test_mime_types_loader.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rubyforge>, [">= 2.0.4"])
      s.add_development_dependency(%q<minitest>, ["~> 5.2"])
      s.add_development_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_development_dependency(%q<hoe-doofus>, ["~> 1.0"])
      s.add_development_dependency(%q<hoe-gemspec2>, ["~> 1.1"])
      s.add_development_dependency(%q<hoe-git>, ["~> 1.5"])
      s.add_development_dependency(%q<hoe-rubygems>, ["~> 1.0"])
      s.add_development_dependency(%q<hoe-travis>, ["~> 1.2"])
      s.add_development_dependency(%q<rake>, ["~> 10.0"])
      s.add_development_dependency(%q<simplecov>, ["~> 0.7"])
      s.add_development_dependency(%q<hoe>, ["~> 3.7"])
    else
      s.add_dependency(%q<rubyforge>, [">= 2.0.4"])
      s.add_dependency(%q<minitest>, ["~> 5.2"])
      s.add_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_dependency(%q<hoe-doofus>, ["~> 1.0"])
      s.add_dependency(%q<hoe-gemspec2>, ["~> 1.1"])
      s.add_dependency(%q<hoe-git>, ["~> 1.5"])
      s.add_dependency(%q<hoe-rubygems>, ["~> 1.0"])
      s.add_dependency(%q<hoe-travis>, ["~> 1.2"])
      s.add_dependency(%q<rake>, ["~> 10.0"])
      s.add_dependency(%q<simplecov>, ["~> 0.7"])
      s.add_dependency(%q<hoe>, ["~> 3.7"])
    end
  else
    s.add_dependency(%q<rubyforge>, [">= 2.0.4"])
    s.add_dependency(%q<minitest>, ["~> 5.2"])
    s.add_dependency(%q<rdoc>, ["~> 4.0"])
    s.add_dependency(%q<hoe-doofus>, ["~> 1.0"])
    s.add_dependency(%q<hoe-gemspec2>, ["~> 1.1"])
    s.add_dependency(%q<hoe-git>, ["~> 1.5"])
    s.add_dependency(%q<hoe-rubygems>, ["~> 1.0"])
    s.add_dependency(%q<hoe-travis>, ["~> 1.2"])
    s.add_dependency(%q<rake>, ["~> 10.0"])
    s.add_dependency(%q<simplecov>, ["~> 0.7"])
    s.add_dependency(%q<hoe>, ["~> 3.7"])
  end
end
