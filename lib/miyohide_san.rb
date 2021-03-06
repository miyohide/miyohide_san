require "uri"
require "date"
require "net/http"
require "ostruct"
require "mongoid"
require "settingslogic"
require 'active_support/all'
require "miyohide_san/version"

module MiyohideSan
  extend ActiveSupport::Autoload

  autoload :Settings
  autoload :Zapierable
  autoload :Event
  autoload :Group
  autoload :GoogleGroup
  autoload :Twitter
  autoload :FacebookGroup
  autoload :Doorkeeper
  autoload :DummyEvent
end

#
# Mongoid Setting
#
Mongoid.load!(File.expand_path('../../config/mongoid.yml', __FILE__), (ENV["RACK_ENV"] || "development"))
