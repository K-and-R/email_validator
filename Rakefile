require 'bundler'
require 'rake/testtask'
begin
  require 'rdoc/task'
rescue LoadError
  require 'rake/rdoctask' # deprecated in Ruby 1.9.3 but needed for Ruby 1.8.7 and JRuby
end
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = %w(--format documentation --colour)
end

Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "email_validator #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

task :default => 'spec'