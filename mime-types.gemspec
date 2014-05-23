# -*- encoding: utf-8 -*-
# stub: mime-types 2.3 ruby lib

Gem::Specification.new do |s|
  s.name = "mime-types"
  s.version = "2.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Austin Ziegler"]
  s.date = "2014-05-23"
  s.description = "The mime-types library provides a library and registry for information about\nMIME content type definitions. It can be used to determine defined filename\nextensions for MIME types, or to use filename extensions to look up the likely\nMIME type definitions.\n\nMIME content types are used in MIME-compliant communications, as in e-mail or\nHTTP traffic, to indicate the type of content which is transmitted. The\nmime-types library provides the ability for detailed information about MIME\nentities (provided as an enumerable collection of MIME::Type objects) to be\ndetermined and used programmatically. There are many types defined by RFCs and\nvendors, so the list is long but by definition incomplete; don't hesitate to to\nadd additional type definitions (see Contributing.rdoc). The primary sources\nfor MIME type definitions found in mime-types is the IANA collection of\nregistrations (see below for the link), RFCs, and W3C recommendations.\n\nThis is release 2.2, mostly changing how the MIME type registry is updated from\nthe IANA registry (the format of which was incompatibly changed shortly before\nthis release) and taking advantage of the extra data available from IANA\nregistry in the form of MIME::Type#xrefs. In addition, the {LTSW\nlist}[http://www.ltsw.se/knbase/internet/mime.htp] has been dropped as a\nsupported list.\n\nAs a reminder, mime-types 2.x is no longer compatible with Ruby 1.8 and\nmime-types 1.x is only being maintained for security issues. No new MIME types\nor features will be added.\n\nmime-types (previously called MIME::Types for Ruby) was originally based on\nMIME::Types for Perl by Mark Overmeer, copyright 2001 - 2009. It is built to\nconform to the MIME types of RFCs 2045 and 2231. It tracks the {IANA Media\nTypes registry}[https://www.iana.org/assignments/media-types/media-types.xhtml]\nwith some types added by the users of mime-types."
  s.email = ["halostatue@gmail.com"]
  s.extra_rdoc_files = ["Contributing.rdoc", "History-Types.rdoc", "History.rdoc", "Licence.rdoc", "Manifest.txt", "README.rdoc", "docs/COPYING.txt", "docs/artistic.txt", "Contributing.rdoc", "History-Types.rdoc", "History.rdoc", "Licence.rdoc", "README.rdoc"]
  s.files = [".autotest", ".coveralls.yml", ".gemtest", ".hoerc", ".minitest.rb", ".travis.yml", "Contributing.rdoc", "Gemfile", "History-Types.rdoc", "History.rdoc", "Licence.rdoc", "Manifest.txt", "README.rdoc", "Rakefile", "data/mime-types.json", "docs/COPYING.txt", "docs/artistic.txt", "lib/mime-types.rb", "lib/mime.rb", "lib/mime/type.rb", "lib/mime/types.rb", "lib/mime/types/cache.rb", "lib/mime/types/loader.rb", "lib/mime/types/loader_path.rb", "support/apache_mime_types.rb", "support/benchmarker.rb", "support/convert.rb", "support/iana_registry.rb", "test/fixture/json.json", "test/fixture/old-data", "test/fixture/yaml.yaml", "test/minitest_helper.rb", "test/test_mime_type.rb", "test/test_mime_types.rb", "test/test_mime_types_cache.rb", "test/test_mime_types_class.rb", "test/test_mime_types_lazy.rb", "test/test_mime_types_loader.rb"]
  s.homepage = "https://github.com/halostatue/mime-types/"
  s.licenses = ["MIT", "Artistic 2.0", "GPL-2"]
  s.rdoc_options = ["--main", "README.rdoc"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")
  s.rubygems_version = "2.2.1"
  s.summary = "The mime-types library provides a library and registry for information about MIME content type definitions"
  s.test_files = ["test/test_mime_type.rb", "test/test_mime_types.rb", "test/test_mime_types_cache.rb", "test/test_mime_types_class.rb", "test/test_mime_types_lazy.rb", "test/test_mime_types_loader.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<minitest>, ["~> 5.3"])
      s.add_development_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_development_dependency(%q<hoe-doofus>, ["~> 1.0"])
      s.add_development_dependency(%q<hoe-gemspec2>, ["~> 1.1"])
      s.add_development_dependency(%q<hoe-git>, ["~> 1.6"])
      s.add_development_dependency(%q<hoe-rubygems>, ["~> 1.0"])
      s.add_development_dependency(%q<hoe-travis>, ["~> 1.2"])
      s.add_development_dependency(%q<rake>, ["~> 10.0"])
      s.add_development_dependency(%q<simplecov>, ["~> 0.7"])
      s.add_development_dependency(%q<coveralls>, ["~> 0.7"])
      s.add_development_dependency(%q<hoe>, ["~> 3.12"])
    else
      s.add_dependency(%q<minitest>, ["~> 5.3"])
      s.add_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_dependency(%q<hoe-doofus>, ["~> 1.0"])
      s.add_dependency(%q<hoe-gemspec2>, ["~> 1.1"])
      s.add_dependency(%q<hoe-git>, ["~> 1.6"])
      s.add_dependency(%q<hoe-rubygems>, ["~> 1.0"])
      s.add_dependency(%q<hoe-travis>, ["~> 1.2"])
      s.add_dependency(%q<rake>, ["~> 10.0"])
      s.add_dependency(%q<simplecov>, ["~> 0.7"])
      s.add_dependency(%q<coveralls>, ["~> 0.7"])
      s.add_dependency(%q<hoe>, ["~> 3.12"])
    end
  else
    s.add_dependency(%q<minitest>, ["~> 5.3"])
    s.add_dependency(%q<rdoc>, ["~> 4.0"])
    s.add_dependency(%q<hoe-doofus>, ["~> 1.0"])
    s.add_dependency(%q<hoe-gemspec2>, ["~> 1.1"])
    s.add_dependency(%q<hoe-git>, ["~> 1.6"])
    s.add_dependency(%q<hoe-rubygems>, ["~> 1.0"])
    s.add_dependency(%q<hoe-travis>, ["~> 1.2"])
    s.add_dependency(%q<rake>, ["~> 10.0"])
    s.add_dependency(%q<simplecov>, ["~> 0.7"])
    s.add_dependency(%q<coveralls>, ["~> 0.7"])
    s.add_dependency(%q<hoe>, ["~> 3.12"])
  end
end
