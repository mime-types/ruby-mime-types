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
  s.rubyforge_project = %q(mime-types)
  s.homepage = %q{http://www.halostatue.ca/ruby/Mime__Types.html}
  s.description = File.read("README")
end
