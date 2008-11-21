require 'rubygems'
require 'rake/gempackagetask'
require 'rubygems/specification'
require 'date'
require "rake/testtask"

GEM = "quicken_parser"
GEM_VERSION = "0.1.2"
AUTHOR = "François Beausoleil"
EMAIL = "francois@teksol.info"
HOMEPAGE = "http://github.com/francois/quicken_parser"
SUMMARY = "This is a quick'n'dirty gem to parse Quicken QFX format."

spec = Gem::Specification.new do |s|
  s.name = GEM
  s.version = GEM_VERSION
  s.platform = Gem::Platform::RUBY
  s.has_rdoc = true
  s.extra_rdoc_files = ["README", "LICENSE", "TODO"]
  s.summary = SUMMARY
  s.description = s.summary
  s.author = AUTHOR
  s.email = EMAIL
  s.homepage = HOMEPAGE

  s.add_dependency "francois-money", "~> 2.0.0.1"
  s.add_development_dependency "francois-shoulda", "~> 2.0"

  s.require_path = "lib"
  s.files = %w(LICENSE README Rakefile TODO) + Dir.glob("{lib,test}/**/*")
end

Rake::GemPackageTask.new(spec) do |pkg|
  pkg.gem_spec = spec
end

desc "install the gem locally"
task :install => [:package] do
  sh %{sudo gem install pkg/#{GEM}-#{GEM_VERSION}}
end

desc "create a gemspec file"
task :make_spec do
  File.open("#{GEM}.gemspec", "w") do |file|
    file.puts spec.to_ruby
  end
end

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/*_test.rb']
  t.verbose    = true
end

task :default => :test
