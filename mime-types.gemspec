# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "mime-types"
  s.version = "1.24"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Austin Ziegler"]
  s.date = "2013-08-14"
  s.description = "This library allows for the identification of a file's likely MIME content\ntype. This is release 1.24, adding and updating a few MIME types and fixing\nsome issues with documentation.\n\nMIME types are used in MIME-compliant communications, as in e-mail or HTTP\ntraffic, to indicate the type of content which is transmitted. MIME::Types\nprovides the ability for detailed information about MIME entities (provided as\na set of MIME::Type objects) to be determined and used programmatically. There\nare many types defined by RFCs and vendors, so the list is long but not\ncomplete; don't hesitate to ask to add additional information. This library\nfollows the IANA collection of MIME types (see below for reference).\n\nMIME::Types for Ruby was originally based on MIME::Types for Perl by Mark\nOvermeer, copyright 2001 - 2009. As of version 1.15, the data format for the\nMIME::Type list has changed and the synchronization will no longer happen.\n\nMIME::Types is built to conform to the MIME types of RFCs 2045 and 2231. It\ntracks the {IANA registry}[http://www.iana.org/assignments/media-types/]\n({ftp}[ftp://ftp.iana.org/assignments/media-types]) with some unofficial types\nadded from the {LTSW collection}[http://www.ltsw.se/knbase/internet/mime.htp]\nand added by the users of MIME::Types."
  s.email = ["austin@rubyforge.org"]
  s.extra_rdoc_files = ["Contributing.rdoc", "History.rdoc", "Licence.rdoc", "Manifest.txt", "README.rdoc", "docs/COPYING.txt", "docs/artistic.txt", "Contributing.rdoc", "History.rdoc", "Licence.rdoc", "README.rdoc"]
  s.files = [".gemtest", ".hoerc", ".travis.yml", "Contributing.rdoc", "Gemfile", "History.rdoc", "Licence.rdoc", "Manifest.txt", "README.rdoc", "Rakefile", "docs/COPYING.txt", "docs/artistic.txt", "lib/mime-types.rb", "lib/mime/types.rb", "lib/mime/types/application", "lib/mime/types/application.mac", "lib/mime/types/application.nonstandard", "lib/mime/types/application.obsolete", "lib/mime/types/audio", "lib/mime/types/audio.nonstandard", "lib/mime/types/audio.obsolete", "lib/mime/types/image", "lib/mime/types/image.nonstandard", "lib/mime/types/image.obsolete", "lib/mime/types/message", "lib/mime/types/message.obsolete", "lib/mime/types/model", "lib/mime/types/multipart", "lib/mime/types/multipart.nonstandard", "lib/mime/types/multipart.obsolete", "lib/mime/types/other.nonstandard", "lib/mime/types/text", "lib/mime/types/text.nonstandard", "lib/mime/types/text.obsolete", "lib/mime/types/text.vms", "lib/mime/types/video", "lib/mime/types/video.nonstandard", "lib/mime/types/video.obsolete", "test/test_mime_type.rb", "test/test_mime_types.rb"]
  s.homepage = "http://mime-types.rubyforge.org/"
  s.licenses = ["MIT", "Artistic 2.0", "GPL-2"]
  s.rdoc_options = ["--main", "README.rdoc"]
  s.require_paths = ["lib"]
  s.rubyforge_project = "mime-types"
  s.rubygems_version = "1.8.25"
  s.summary = "This library allows for the identification of a file's likely MIME content type"
  s.test_files = ["test/test_mime_type.rb", "test/test_mime_types.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rubyforge>, [">= 2.0.4"])
      s.add_development_dependency(%q<minitest>, ["~> 5.0"])
      s.add_development_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_development_dependency(%q<hoe-bundler>, ["~> 1.2"])
      s.add_development_dependency(%q<hoe-doofus>, ["~> 1.0"])
      s.add_development_dependency(%q<hoe-gemspec2>, ["~> 1.1"])
      s.add_development_dependency(%q<hoe-git>, ["~> 1.5"])
      s.add_development_dependency(%q<hoe-rubygems>, ["~> 1.0"])
      s.add_development_dependency(%q<hoe-travis>, ["~> 1.2"])
      s.add_development_dependency(%q<rake>, ["~> 10.0"])
      s.add_development_dependency(%q<hoe>, ["~> 3.7"])
    else
      s.add_dependency(%q<rubyforge>, [">= 2.0.4"])
      s.add_dependency(%q<minitest>, ["~> 5.0"])
      s.add_dependency(%q<rdoc>, ["~> 4.0"])
      s.add_dependency(%q<hoe-bundler>, ["~> 1.2"])
      s.add_dependency(%q<hoe-doofus>, ["~> 1.0"])
      s.add_dependency(%q<hoe-gemspec2>, ["~> 1.1"])
      s.add_dependency(%q<hoe-git>, ["~> 1.5"])
      s.add_dependency(%q<hoe-rubygems>, ["~> 1.0"])
      s.add_dependency(%q<hoe-travis>, ["~> 1.2"])
      s.add_dependency(%q<rake>, ["~> 10.0"])
      s.add_dependency(%q<hoe>, ["~> 3.7"])
    end
  else
    s.add_dependency(%q<rubyforge>, [">= 2.0.4"])
    s.add_dependency(%q<minitest>, ["~> 5.0"])
    s.add_dependency(%q<rdoc>, ["~> 4.0"])
    s.add_dependency(%q<hoe-bundler>, ["~> 1.2"])
    s.add_dependency(%q<hoe-doofus>, ["~> 1.0"])
    s.add_dependency(%q<hoe-gemspec2>, ["~> 1.1"])
    s.add_dependency(%q<hoe-git>, ["~> 1.5"])
    s.add_dependency(%q<hoe-rubygems>, ["~> 1.0"])
    s.add_dependency(%q<hoe-travis>, ["~> 1.2"])
    s.add_dependency(%q<rake>, ["~> 10.0"])
    s.add_dependency(%q<hoe>, ["~> 3.7"])
  end
end
