Gem::Specification.new do |s|
  s.name = %q{mime-types}
  s.version = %q{1.15}
  s.summary = %q{Manages a MIME Content-Type that will return the Content-Type for a given filename.}
  s.platform = Gem::Platform::RUBY

  s.has_rdoc = true
  s.rdoc_options = %w(--title MIME::Types --main README --line-numbers)
  s.extra_rdoc_files = %w(README ChangeLog Install)

  s.test_files = %w{tests/testall.rb}

  s.require_paths = %w{lib}

  s.files = FileList[*%w(bin/**/* lib/**/* tests/**/* ChangeLog README
                         LICENCE setup.rb Rakefile mime-types.gemspec
                         pre-setup.rb)].to_a.delete_if do |item|
    item.include?("CVS") or item.include?(".svn") or
    item == "install.rb" or item =~ /~$/ or
    item =~ /gem(?:spec)?$/
  end

  s.author = %q{Austin Ziegler}
  s.email = %q{austin@rubyforge.org}
  s.rubyforge_project = %q(mime-types)
  s.homepage = %q{http://mime-types.rubyforge.org/}

  description = []
  File.open("README") do |file|
    file.each do |line|
      line.chomp!
      break if line.empty?
      description << "#{line.gsub(/\[\d\]/, '')}"
    end
  end
  s.description = description[1..-1].join(" ")
end
