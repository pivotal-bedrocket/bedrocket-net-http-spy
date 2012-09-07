require "rubygems"
require "rubygems/package_task"
require "rdoc/task"
require 'rspec/core/rake_task'

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gemspec|
    gemspec.name = "paso-net-http-spy"
    gemspec.summary = "Ever wondered what HTTP requests the Ruby gem you are using to connect to a third party API is making? Use HTTP Spy to see what is going on behind the scenes."
    gemspec.email = "patrik@booli.se"
    gemspec.homepage = "http://github.com/Paso/net-http-spy"
    gemspec.description = "Ever wondered what HTTP requests the Ruby gem you are using to connect to a third party API is making? Use HTTP Spy to see what is going on behind the scenes."
    gemspec.authors = ["Martin Sadler", "Patrik Soderberg"]
    gemspec.files.include Dir["examples/*.rb"] + ["readme.markdown"]
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

task :default => :spec
RSpec::Core::RakeTask.new

# Generate documentation
Rake::RDocTask.new do |rd|
  rd.main = "readme.markdown"
  rd.rdoc_files.include("readme.markdown", "lib/**/*.rb")
  rd.rdoc_dir = "rdoc"
end

desc 'Clear out RDoc and generated packages'
task :clean => [:clobber_rdoc, :clobber_package] do
  rm "#{spec.name}.gemspec"
end
