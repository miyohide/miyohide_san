File.expand_path('../lib', __FILE__).tap do |lib|
  $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
end

if ENV["RACK_ENV"] != 'production'
  require 'bundler/gem_tasks'
  require 'rspec/core/rake_task'
  # Default directory to look in is `/specs`
  # Run with `rake spec`
  RSpec::Core::RakeTask.new(:spec) do |task|
    task.rspec_opts = ['--color', '--format', 'nested']
  end
end

require 'miyohide_san'
task :environment do
  FileUtils.mkdir_p(MiyohideSan::LastEvent::CACHE_DIR)
end

desc 'イベント開始一週間前に通知する'
task testament: :environment do
  MiyohideSan.testament
end

desc 'イベント募集開始時に通知する'
task newborn: :environment do
  MiyohideSan.newborn
end

task :default => [:environment, :spec]
