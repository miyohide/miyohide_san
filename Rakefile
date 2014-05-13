if ENV["RACK_ENV"] != 'production'
  require 'bundler/gem_tasks'
  require 'rspec/core/rake_task'
  # Default directory to look in is `/specs`
  # Run with `rake spec`
  RSpec::Core::RakeTask.new(:spec) do |task|
    task.rspec_opts = ['--color', '--format', 'nested']
  end
end

require './lib/miyohide_san'
namespace "miyohide_san" do
  desc 'miyohide_san notify'
  task :notify do
    MiyohideSan.notify
  end
end

task :default => :spec
