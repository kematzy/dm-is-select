require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'

require 'jeweler'
Jeweler::Tasks.new do |gem|
  # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  gem.name = "dm-is-select"
  gem.homepage = "http://github.com/kematzy/dm-is-select"
  gem.license = "MIT"
  gem.summary = %Q{A DataMapper plugin that makes getting the <tt>select</tt> options from a Model easier.}
  gem.description = %Q{A DataMapper plugin that makes getting the <tt>select</tt> options from a Model easier.}
  gem.email = "kematzy@gmail.com"
  gem.authors = ["kematzy"]
  gem.extra_rdoc_files = %w[ README.rdoc LICENSE TODO History.rdoc ]
  gem.files = `git ls-files`.split($\)
  # dependencies defined in Gemfile  
end
Jeweler::RubygemsDotOrgTasks.new

require 'rspec/core'
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = FileList['spec/**/*_spec.rb']
end

RSpec::Core::RakeTask.new(:rcov) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
  spec.rcov = true
end

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""
  
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "dm-is-select #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

desc 'Build the *sdoc* HTML files'
task :docs do
  version = File.exist?('VERSION') ? IO.read('VERSION').chomp : "[Unknown]"
  
  sh "sdoc -N --title 'DM::Is::Select v#{version}' --exclude spec --O '#{Dir.pwd}/docs' lib/ README.rdoc"
end

# encoding: utf-8

