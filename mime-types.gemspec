# -*- encoding: utf-8 -*-
# stub: mime-types 2.99.3 ruby lib

Gem::Specification.new do |s|
  s.name = "mime-types"
  s.version = "2.99.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Austin Ziegler"]
  s.date = "2016-09-11"
  s.description = "The mime-types library provides a library and registry for information about\nMIME content type definitions. It can be used to determine defined filename\nextensions for MIME types, or to use filename extensions to look up the likely\nMIME type definitions.\n\nThis is release 2.99.1, the first scheduled data update for mime-types 2.x. As\nof mime-types 2.99. deprecation warnings are noisy and data that has been\ndeprecated is now no longer available. The data is both dropped from the data\nfiles and is stubbed out as empty or +nil+ values as appropriate.\n\nmime-types-2.6 was the last version of mime-types 2.x with newly available\nfeatures, and mime-types 2.99 will only receive quarterly updates to the IANA\nregistered MIME media types plus any security updates that may be required.\n\nIf the loss of the deprecated data matters, be sure to set your dependency\nappropriately:\n\n   gem 'mime-types', '~> 2.6, < 2.99'"
  s.email = ["halostatue@gmail.com"]
  s.extra_rdoc_files = ["Code-of-Conduct.rdoc", "Contributing.rdoc", "History-Types.rdoc", "History.rdoc", "Licence.rdoc", "Manifest.txt", "README.rdoc", "docs/COPYING.txt", "docs/artistic.txt", "Code-of-Conduct.rdoc", "Contributing.rdoc", "History-Types.rdoc", "History.rdoc", "Licence.rdoc", "README.rdoc"]
  s.files = ["Code-of-Conduct.rdoc", "Contributing.rdoc", "History-Types.rdoc", "History.rdoc", "Licence.rdoc", "Manifest.txt", "README.rdoc", "Rakefile", "data/mime-types.json", "data/mime.content_type.column", "data/mime.docs.column", "data/mime.encoding.column", "data/mime.friendly.column", "data/mime.obsolete.column", "data/mime.registered.column", "data/mime.signature.column", "data/mime.use_instead.column", "data/mime.xrefs.column", "docs/COPYING.txt", "docs/artistic.txt", "lib/mime-types.rb", "lib/mime/type.rb", "lib/mime/type/columnar.rb", "lib/mime/types.rb", "lib/mime/types/cache.rb", "lib/mime/types/columnar.rb", "lib/mime/types/deprecations.rb", "lib/mime/types/loader.rb", "lib/mime/types/loader_path.rb", "lib/mime/types/logger.rb", "support/apache_mime_types.rb", "support/benchmarks/load.rb", "support/benchmarks/load_allocations.rb", "support/benchmarks/object_counts.rb", "support/convert.rb", "support/convert/columnar.rb", "support/iana_registry.rb", "test/bad-fixtures/malformed", "test/fixture/json.json", "test/fixture/old-data", "test/fixture/yaml.yaml", "test/minitest_helper.rb", "test/test_mime_type.rb", "test/test_mime_types.rb", "test/test_mime_types_cache.rb", "test/test_mime_types_class.rb", "test/test_mime_types_lazy.rb", "test/test_mime_types_loader.rb"]
  s.homepage = "https://github.com/mime-types/ruby-mime-types/"
  s.licenses = ["MIT", "Artistic-2.0", "GPL-2.0"]
  s.rdoc_options = ["--main", "README.rdoc"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")
  s.rubygems_version = "2.5.1"
  s.summary = "The mime-types library provides a library and registry for information about MIME content type definitions"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<minitest>, ["~> 5.9"])
      s.add_development_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_development_dependency(%q<hoe-doofus>, ["~> 1.0"])
      s.add_development_dependency(%q<hoe-gemspec2>, ["~> 1.1"])
      s.add_development_dependency(%q<hoe-git>, ["~> 1.6"])
      s.add_development_dependency(%q<hoe-rubygems>, ["~> 1.0"])
      s.add_development_dependency(%q<hoe-travis>, ["~> 1.2"])
      s.add_development_dependency(%q<minitest-autotest>, ["~> 1.0"])
      s.add_development_dependency(%q<minitest-focus>, ["~> 1.0"])
      s.add_development_dependency(%q<rake>, ["~> 10.0"])
      s.add_development_dependency(%q<fivemat>, ["~> 1.3"])
      s.add_development_dependency(%q<minitest-rg>, ["~> 5.2"])
      s.add_development_dependency(%q<hoe>, ["~> 3.15"])
    else
      s.add_dependency(%q<minitest>, ["~> 5.9"])
      s.add_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_dependency(%q<hoe-doofus>, ["~> 1.0"])
      s.add_dependency(%q<hoe-gemspec2>, ["~> 1.1"])
      s.add_dependency(%q<hoe-git>, ["~> 1.6"])
      s.add_dependency(%q<hoe-rubygems>, ["~> 1.0"])
      s.add_dependency(%q<hoe-travis>, ["~> 1.2"])
      s.add_dependency(%q<minitest-autotest>, ["~> 1.0"])
      s.add_dependency(%q<minitest-focus>, ["~> 1.0"])
      s.add_dependency(%q<rake>, ["~> 10.0"])
      s.add_dependency(%q<fivemat>, ["~> 1.3"])
      s.add_dependency(%q<minitest-rg>, ["~> 5.2"])
      s.add_dependency(%q<hoe>, ["~> 3.15"])
    end
  else
    s.add_dependency(%q<minitest>, ["~> 5.9"])
    s.add_dependency(%q<rdoc>, ["~> 4.0"])
    s.add_dependency(%q<hoe-doofus>, ["~> 1.0"])
    s.add_dependency(%q<hoe-gemspec2>, ["~> 1.1"])
    s.add_dependency(%q<hoe-git>, ["~> 1.6"])
    s.add_dependency(%q<hoe-rubygems>, ["~> 1.0"])
    s.add_dependency(%q<hoe-travis>, ["~> 1.2"])
    s.add_dependency(%q<minitest-autotest>, ["~> 1.0"])
    s.add_dependency(%q<minitest-focus>, ["~> 1.0"])
    s.add_dependency(%q<rake>, ["~> 10.0"])
    s.add_dependency(%q<fivemat>, ["~> 1.3"])
    s.add_dependency(%q<minitest-rg>, ["~> 5.2"])
    s.add_dependency(%q<hoe>, ["~> 3.15"])
  end
end
