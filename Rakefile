begin
  require 'jeweler'

  Jeweler::Tasks.new do |gem|
    gem.name = "mediocre_chess"
    gem.summary = "Chess utility functions using the Mediocre chess engine"
    gem.description = "Chess utility functions in JRuby that wrap the Mediocre chess engine (http://mediocrechess.blogspot.com/)." 
    gem.email = "joey@joeyrobert.org"
    gem.homepage = "https://github.com/joeyrobert/mediocre_chess"
    gem.authors = ["Joey Robert"]
    gem.files = Dir.glob('lib/**/*')
  end
rescue LoadError
  puts "Jeweler, or one of its dependencies, is not available. Install with gem install jeweler."
end

require 'rspec/core/rake_task'

desc 'Default: run specs.'
task :default => :spec

desc 'Run the specs'
RSpec::Core::RakeTask.new do |t|
  t.rspec_opts = ["-c", "-f progress", "-r ./spec/spec_helper.rb", "--format documentation"]
  t.pattern = 'spec/**/*_spec.rb'
end
