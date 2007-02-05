##
# Install utility for HaloStatue scripts and libraries. Based heavily on the
# original RDoc installation script by Pragmatic Programmers.
#
require 'rbconfig'
require 'find'
require 'fileutils'
require 'rdoc/rdoc'
require 'optparse'
require 'ostruct'
require 'test/unit/ui/console/testrunner'

InstallOptions = OpenStruct.new

  # Set these values to what you want installed.
bins  = %w{bin/**/*}
rdoc  = %w{bin/**/*.rb lib/**/*.rb}
ri    = %w(bin/**/*.rb lib/**/*.rb)
libs  = %w{lib/**/*.rb}
tests = %w{tests/**/*.rb}

def do_bins(bins, strip = 'bin/')
  bins.each do |bf|
    obf = bf.gsub(/#{strip}/, '')
    install_binfile(bf, obf)
  end
end

def do_libs(libs, strip = 'lib/')
  libs.each do |lf|
    olf = File.join(InstallOptions.site_dir, lf.gsub(/#{strip}/, ''))
    op = File.dirname(olf)
    File.makedirs(op, true)
    File.chmod(0755, op)
    File.install(lf, olf, 0755, true)
  end
end

##
# Prepare the file installation.
#
def prepare_installation
  InstallOptions.rdoc  = true
  InstallOptions.ri    = true
  InstallOptions.tests = true

  ARGV.options do |opts|
    opts.banner = "Usage: #{File.basename($0)} [options]"
    opts.separator ""
    opts.on('--no-rdoc', FalseClass,
            'Prevents the creation of RDoc output.') do |onrdoc|
      InstallOptions.rdoc = onrdoc
    end
    opts.on('--no-ri', FalseClass,
            'Prevents the creation of RI output.') do |onri|
      InstallOptions.ri = onri
    end
    opts.on('--no-tests', FalseClass,
            'Prevents the execution of nit tests.') do |ontest|
      InstallOptions.tests = ontest
    end
    opts.separator("")
    opts.on_tail('--help', "Shows this help text.") do
      $stderr.puts opts
      exit
    end

    opts.parse!
  end

  bds = [".", ENV['TMP'], ENV['TEMP']]

  version = [Config::CONFIG["MAJOR"], Config::CONFIG["MINOR"]].join(".")
  ld = File.join(Config::CONFIG["libdir"], "ruby", version)

  sd = Config::CONFIG["sitelibdir"]
  if sd.nil?
    sd = $:.find { |x| x =~ /site_ruby/ }
    if sd.nil?
      sd = File.join(ld, "site_ruby")
    elsif sd !~ Regexp.quote(version)
      sd = File.join(sd, version)
    end
  end

  if (destdir = ENV['DESTDIR'])
    bd = "#{destdir}#{Config::CONFIG['bindir']}"
    sd = "#{destdir}#{sd}"
    bds << bd

    FileUtils.makedirs(bd)
    FileUtils.makedirs(sd)
  else
    bds << Config::CONFIG['bindir']
  end

  InstallOptions.bin_dirs = bds.compact
  InstallOptions.site_dir = sd
  InstallOptions.bin_dir  = bd
  InstallOptions.lib_dir  = ld
end

##
# Build the rdoc documentation. Also, try to build the RI documentation.
#
def build_rdoc(files)
  r = RDoc::RDoc.new
  r.document(%w{--line-numbers --show-hash} + files)
rescue RDoc::RDocError => e
  $stderr.puts e.message
end

def build_ri(files)
  ri = RDoc::RDoc.new
  ri.document(%w{--ri-site --line-numbers --show-hash} + files)
rescue RDoc::RDocError => e
  $stderr.puts e.message
end

def run_tests(test_list)
  $:.unshift "lib"
  test_list.each do |test|
    next if File.directory?(test)
    require test
  end

  tests = []
  ObjectSpace.each_object { |o| tests << o if o.kind_of?(Class) } 
  tests.delete_if { |o| !o.ancestors.include?(Test::Unit::TestCase) }
  tests.delete_if { |o| o == Test::Unit::TestCase }

  tests.each { |test| Test::Unit::UI::Console::TestRunner.run(test) }
  $:.shift
end

##
# Install file(s) from ./bin to Config::CONFIG['bindir']. Patch it on the way
# to insert a #! line; on a Unix install, the command is named as expected
# (e.g., bin/rdoc becomes rdoc); the shebang line handles running it. Under
# windows, we add an '.rb' extension and let file associations do their stuff.
def install_binfile(from, op_file)
  tmp_dir = nil
  BinDirs.each do |t|
    stat = File.stat(t) rescue next
    if stat.directory? and stat.writable?
      tmp_dir = t
      break
    end
  end
  
  fail "Cannot finda  temporary directory" unless tmp_dir
  tmp_file = File.join(tmp_dir, '_tmp')

  File.open(from) do |ip|
    File.open(tmp_file, "w") do |op|
      ruby = File.join(Config::CONFIG['bindir'], Config::CONFIG['ruby_install_name'])
      op.puts "#!#{ruby}"
      op.write ip.read
    end
  end

  opfile += ".rb" if Config::CONFIG["target_os"] =~ /win/
  FileUtils.install(tmp_file, File.join(TargetBinDir, opfile), 0755, true)
  FileUtils.unlink(tmp_file)
end

def glob(list)
  g = []
  list.each { |i| g << Dir.glob(i) }
  g.flatten!
  g.compact!
  g
end

prepare_installation

bins  = glob(bins)
rdoc  = glob(rdoc)
ri    = glob(ri)
libs  = glob(libs)
tests = glob(tests)

run_tests(tests) if InstallOptions.tests
build_rdoc(rdoc) if InstallOptions.rdoc
build_ri(ri) if InstallOptions.ri
do_bins(bins)
do_libs(libs)
