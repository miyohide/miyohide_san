if ENV['CODECLIMATE_REPO_TOKEN']
  require "codeclimate-test-reporter"
  CodeClimate::TestReporter.start
end

require 'miyohide_san'
require 'pry'
require 'vcr'
require 'webmock/rspec'
require 'factory_girl'
require 'forgery'
require 'named_let'
require 'timecop'
require 'factories'
require 'rspec/json_matcher'
require 'shoulda/matchers'
require 'database_cleaner'

ENV['RACK_ENV'] ||= "test"

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include RSpec::JsonMatcher
  config.order = "random"

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean_with(:truncation)
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr'
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = true
end
