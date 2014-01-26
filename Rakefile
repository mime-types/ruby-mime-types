# -*- ruby encoding: utf-8 -*-

require 'rubygems'
require 'hoe'

Hoe.plugin :doofus
Hoe.plugin :email
Hoe.plugin :gemspec2
Hoe.plugin :git
Hoe.plugin :rubyforge unless ENV['CI'] or ENV['TRAVIS']
Hoe.plugin :minitest
Hoe.plugin :travis

spec = Hoe.spec 'mime-types' do
  developer('Austin Ziegler', 'austin@rubyforge.org')
  self.need_tar = true

  self.require_ruby_version '>= 1.9.2'

  self.remote_rdoc_dir = '.'
  self.rsync_args << ' --exclude=statsvn/'

  self.history_file = 'History.rdoc'
  self.readme_file = 'README.rdoc'
  self.extra_rdoc_files = FileList["*.rdoc"].to_a
  self.licenses = ["MIT", "Artistic 2.0", "GPL-2"]

  self.extra_dev_deps << ['hoe-doofus', '~> 1.0']
  self.extra_dev_deps << ['hoe-gemspec2', '~> 1.1']
  self.extra_dev_deps << ['hoe-git', '~> 1.5']
  self.extra_dev_deps << ['hoe-rubygems', '~> 1.0']
  self.extra_dev_deps << ['hoe-travis', '~> 1.2']
  self.extra_dev_deps << ['minitest', '~> 4.5']
  self.extra_dev_deps << ['rake', '~> 10.0']
  self.extra_dev_deps << ['simplecov', '~> 0.7']
end

desc 'Benchmark'
task :benchmark, :repeats do |t, args|
  $LOAD_PATH.unshift('support')
  require 'benchmarker'

  Benchmarker.benchmark(args.repeats)
end

namespace :test do
  task :coverage do
    spec.test_prelude = [
      'require "simplecov"',
      'SimpleCov.start("test_frameworks") { command_name "Minitest" }',
      'gem "minitest"'
    ].join('; ')
    Rake::Task['test'].execute
  end
end

namespace :mime do
  desc "Download the current MIME type registrations from IANA."
  task :iana, :destination do |t, args|
    $LOAD_PATH.unshift('support')
    require 'iana_registry'
    IANARegistry.download(to: args.destination)
  end

  desc "Download the current MIME type configuration from Apache."
  task :apache, :destination do |t, args|
    $LOAD_PATH.unshift('support')
    require 'apache_mime_types'
    ApacheMIMETypes.download(to: args.destination)
  end
end

Rake::Task['gem'].prerequisites.unshift("convert:yaml:json")

namespace :convert do
  namespace :yaml do
    desc "Convert from YAML to JSON"
    task :json, :source, :destination, :multiple_files do |t, args|
      $LOAD_PATH.unshift('support')
      require 'convert'
      Convert.from_yaml_to_json(args)
    end
  end

  namespace :json do
    desc "Convert from JSON to YAML"
    task :yaml, :source, :destination, :multiple_files do |t, args|
      $LOAD_PATH.unshift('support')
      require 'convert'
      Convert.from_json_to_yaml(args)
    end
  end
end

# vim: syntax=ruby
