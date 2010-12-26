require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new :spec

desc 'Run signore console'
task :console do
  require 'irb'
  require_relative 'lib/signore'
  include Signore
  ARGV.clear
  IRB.start
end
