desc 'イベント募集開始時に通知する'
task :fetch do
  MiyohideSan::Event.fetch!
end

desc 'イベント開始一週間前に通知する'
task :recent do
  MiyohideSan::Event.recent!
end

desc 'doorkeeperからイベント一覧を取得する'
task :sync do
  MiyohideSan::Event.fetch!(false)
end

desc '古いイベントを削除する'
task :clean do
  MiyohideSan::Event.clean!
end

namespace :zapier do
  desc 'Twitter向けの送信テストを行う'
  task :twitter do
    twitter = MiyohideSan::Twitter::NewEvent.new(MiyohideSan::DummyEvent.new)
    twitter.post
  end

  desc 'FacebookGroup向けの送信テストを行う'
  task :facebook_group do
    facebook_group = MiyohideSan::FacebookGroup::NewEvent.new(MiyohideSan::DummyEvent.new)
    facebook_group.post
  end

  desc 'GooleGroup向けの送信テストを行う'
  task :google_group do
    google_group = MiyohideSan::GoogleGroup::NewEvent.new(MiyohideSan::DummyEvent.new)
    google_group.post
  end
end
