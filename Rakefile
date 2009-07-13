require 'rubygems'
require 'rake'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "dm-is-select"
    # gem.version = IO.read('VERSION')
    gem.summary = %Q{A DataMapper plugin that makes getting the <tt><select></tt> options from a Model easier.}
    gem.description = gem.summary
    gem.email = "kematzy@gmail.com"
    gem.homepage = "http://github.com/kematzy/dm-is-select"
    gem.authors = ["kematzy"]
    gem.extra_rdoc_files = %w[ README.rdoc LICENSE TODO History.txt ]
    gem.add_dependency('dm-core', '>= 0.10.0')
    gem.add_dependency('dm-more', '>= 0.10.0')
    # gem.add_dependency('dm-validations', '>= 0.10.0')
    
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end

rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: sudo gem install jeweler"
end

require 'spec/rake/spectask'
Spec::Rake::SpecTask.new(:spec) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.spec_files = FileList['spec/**/*_spec.rb']
end

Spec::Rake::SpecTask.new(:rcov) do |spec|
  spec.libs << 'lib' << 'spec'
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

namespace :spec do

  desc "Run all specifications verbosely"
  Spec::Rake::SpecTask.new(:verbose) do |t|
    t.libs << "lib"
    t.spec_opts = ["--color", "--format", "specdoc", "--require", "spec/spec_helper.rb"]
  end
  
  desc "Run specific spec verbosely (SPEC=/path/2/file)"
  Spec::Rake::SpecTask.new(:select) do |t|
    t.libs << "lib"
    t.spec_files = [ENV["SPEC"]]
    t.spec_opts = ["--color", "--format", "specdoc", "--require", "spec/spec_helper.rb"] 
  end
  
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION')
    version = IO.read('VERSION').chomp
  else
    version = "[Unknown]"
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "dm-is-select #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

# kept just as a reference for now. 
# 
# def sudo_gem(cmd)
#   sh "#{SUDO} #{RUBY} -S gem #{cmd}", :verbose => false
# end
# 
# desc "Install #{GEM_NAME} #{GEM_VERSION}"
# task :install => [ :package ] do
#   sudo_gem "install --local pkg/#{GEM_NAME}-#{GEM_VERSION} --no-update-sources"
# end
# 
# desc "Uninstall #{GEM_NAME} #{GEM_VERSION}"
# task :uninstall => [ :clobber ] do
#   sudo_gem "uninstall #{GEM_NAME} -v#{GEM_VERSION} -Ix"
# end
