File.expand_path('../lib', __FILE__).tap do |lib|
  $LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
end

if ENV["RACK_ENV"] != 'production'
  require 'bundler/gem_tasks'
  require 'rspec/core/rake_task'
  # Default directory to look in is `/specs`
  # Run with `rake spec`
  RSpec::Core::RakeTask.new(:spec) do |task|
    task.rspec_opts = ['--color', '--format', 'documentation']
  end
end

require 'miyohide_san'
include MiyohideSan

desc 'イベント募集開始時に通知する'
task :fetch do
  Event.fetch!
end

desc 'イベント開始一週間前に通知する'
task :recent do
  Event.recent!
end

desc 'doorkeeperからイベント一覧を取得する'
task :sync do
  Event.fetch!(false)
end

namespace :zapier do
  desc 'Twitter向けの送信テストを行う'
  task :twitter do
    twitter = Twitter::NewEvent.new(DummyEvent.new)
    twitter.post
  end

  desc 'FacebookGroup向けの送信テストを行う'
  task :facebook_group do
    facebook_group = FacebookGroup::NewEvent.new(DummyEvent.new)
    facebook_group.post
  end

  desc 'GooleGroup向けの送信テストを行う'
  task :google_group do
    google_group = GoogleGroup::NewEvent.new(DummyEvent.new)
    google_group.post
  end
end

task :default => :spec
