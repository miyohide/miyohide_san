require "codeclimate-test-reporter"
CodeClimate::TestReporter.start

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

ENV['RACK_ENV'] ||= "test"

RSpec.configure do |config|
  config.include FactoryGirl::Syntax::Methods
  config.include RSpec::JsonMatcher
  config.order = "random"
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/vcr'
  config.hook_into :webmock
  config.allow_http_connections_when_no_cassette = true
end
