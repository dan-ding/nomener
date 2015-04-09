require "bundler/gem_tasks"

begin
  require 'rspec/core/rake_task'

  #RSpec::Core::RakeTask.new(:spec)
  #task :default => :spec

rescue LoadError

end

task :default do
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.pattern = 'spec/nomener/*_spec.rb'
  end
  Rake::Task["spec"].execute
end

task :names do
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.pattern = 'spec/nomener/names/*_spec.rb'
  end
  Rake::Task["spec"].execute
end

task :rspec do
  RSpec::Core::RakeTask.new(:spec)
  Rake::Task["spec"].execute
end