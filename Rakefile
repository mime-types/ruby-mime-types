#! /usr/bin/env rake
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

require 'rubygems'
require 'hoe'

$LOAD_PATH.unshift('lib')

require 'mime/types'

PKG_NAME    = 'mime-types'
PKG_VERSION = MIME::Types::VERSION
PKG_DIST    = "#{PKG_NAME}-#{PKG_VERSION}"
PKG_TAR     = "pkg/#{PKG_DIST}.tar.gz"
MANIFEST    = File.read("Manifest.txt").split

Hoe.new PKG_NAME, PKG_VERSION do |p|
  p.rubyforge_name  = PKG_NAME
  # This is a lie because I will continue to use Archive::Tar::Minitar.
  p.need_tar        = false
  # need_zip - Should package create a zipfile? [default: false]

  p.author          = [ "Austin Ziegler" ]
  p.email           = %W(austin@rubyforge.org)
  p.url             = "http://mime-types.rubyforge.org/"
  p.summary         = %q{Manages a MIME Content-Type database that will return the Content-Type for a given filename.}
  p.changes         = p.paragraphs_of("History.txt", 0..1).join("\n\n")
  p.description     = p.paragraphs_of("Readme.txt", 1..1).join("\n\n")

  p.extra_deps      << [ "archive-tar-minitar", "~>0.5.1" ]

  p.clean_globs     << "coverage"

  p.spec_extras[:extra_rdoc_files] = MANIFEST.grep(/txt$/) -
    ["Manifest.txt"]
end

desc "Build a MIME::Types .tar.gz distribution."
task :tar => [ PKG_TAR ]
file PKG_TAR => [ :test ] do |t|
  require 'archive/tar/minitar'
  require 'zlib'
  files = MANIFEST.map { |f|
    fn = File.join(PKG_DIST, f)
    tm = File.stat(f).mtime

    if File.directory?(f)
      { :name => fn, :mode => 0755, :dir => true, :mtime => tm }
    else
      mode = if f =~ %r{^bin}
               0755
             else
               0644
             end
      data = File.read(f)
      { :name => fn, :mode => mode, :data => data, :size => data.size,
        :mtime => tm }
    end
  }

  begin
    unless File.directory?(File.dirname(t.name))
      require 'fileutils'
      File.mkdir_p File.dirname(t.name)
    end
    tf = File.open(t.name, 'wb')
    gz = Zlib::GzipWriter.new(tf)
    tw = Archive::Tar::Minitar::Writer.new(gz)

    files.each do |entry|
      if entry[:dir]
        tw.mkdir(entry[:name], entry)
      else
        tw.add_file_simple(entry[:name], entry) { |os|
          os.write(entry[:data])
        }
      end
    end
  ensure
    tw.close if tw
    gz.close if gz
  end
end
task :package => [ PKG_TAR ]

desc "Build the manifest file from the current set of files."
task :build_manifest do |t|
  require 'find'

  paths = []
  Find.find(".") do |path|
    next if File.directory?(path)
    next if path =~ /\.svn/
    next if path =~ /\.git/
    next if path =~ /\.swp$/
    next if path =~ %r{coverage/}
    next if path =~ /~$/
    paths << path.sub(%r{^\./}, '')
  end

  File.open("Manifest.txt", "w") do |f|
    f.puts paths.sort.join("\n")
  end

  puts paths.sort.join("\n")
end
